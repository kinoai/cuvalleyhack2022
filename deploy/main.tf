resource "aws_vpc" "prod-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "CuValley"
  }
}

resource "aws_subnet" "subnet-1" {
  vpc_id            = aws_vpc.prod-vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = var.availability_zone
  tags = {
    Name = "Cuvalley-Subnet-1"
  }
}


resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.prod-vpc.id
}

resource "aws_route_table" "cuvalley-rt" {
  vpc_id = aws_vpc.prod-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "Cuvalley Route Table"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet-1.id
  route_table_id = aws_route_table.cuvalley-rt.id
}

resource "aws_security_group" "allow_web" {
  name        = "allow_web_traffic"
  description = "Allow Web inbound traffic"
  vpc_id      = aws_vpc.prod-vpc.id
  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "allow_web"
  }
}

resource "aws_network_interface" "cuvalley-nic" {
  subnet_id       = aws_subnet.subnet-1.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.allow_web.id]
}

resource "aws_eip" "cuvalley_eip" {
  vpc                       = true
  network_interface         = aws_network_interface.cuvalley-nic.id
  associate_with_private_ip = "10.0.1.50"
  depends_on                = [aws_internet_gateway.gw]
}


resource "aws_instance" "cuvalley-ec2" {
  ami               = "ami-04505e74c0741db8d"
  instance_type     = var.instance_type
  availability_zone = var.availability_zone
  key_name          = var.key_name

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.cuvalley-nic.id
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    password    = ""
    port        = 22
    private_key = file("~/.ssh/cuvalley.pem")
    host        = aws_eip.cuvalley_eip.public_ip
  }

  provisioner "file" {
    source      = "scripts/install_docker.sh"
    destination = "/tmp/install_docker.sh"

  }
  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/install_docker.sh",
      "sudo /tmp/install_docker.sh",
    ]

  }
  provisioner "local-exec" {
    command = "aws ec2 reboot-instances --instance-ids $(self.id)"
  }

  tags = {
    Name = var.instance_name
  }
}
## FE


resource "aws_s3_bucket" "cuvalley-front" {
    bucket = "cuvalley-front"
}

resource "aws_s3_bucket_public_access_block" "s3-block" {
  bucket = aws_s3_bucket.cuvalley-front.id

  block_public_acls         = true
  block_public_policy       = true
  restrict_public_buckets   = true
  ignore_public_acls        = true
}


resource "aws_s3_bucket_cors_configuration" "s3_cors" {
  bucket = aws_s3_bucket.cuvalley-front.bucket

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT", "POST"]
    allowed_origins = ["${aws_cloudfront_distribution.front.domain_name}"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }

  cors_rule {
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
  }
}

resource "aws_s3_bucket_website_configuration" "example" {
  bucket = aws_s3_bucket.cuvalley-front.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }

  }


data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.cuvalley-front.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn]
    }
  }
}



resource "aws_s3_bucket_policy" "web" {
  bucket = aws_s3_bucket.cuvalley-front.id
  policy = data.aws_iam_policy_document.s3_policy.json
}


resource "aws_cloudfront_distribution" "front" {
  depends_on = [
    aws_s3_bucket.cuvalley-front
  ]

  origin {
    domain_name = aws_s3_bucket.cuvalley-front.bucket_regional_domain_name
    origin_id   = "s3-cloudfront"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "s3-cloudfront"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }
  price_class = "PriceClass_200"


  viewer_certificate {
    cloudfront_default_certificate = true
  }

}

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "access-identity-s3.amazonaws.com"
}


