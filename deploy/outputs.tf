output "ec2_public_ip" {
  value = aws_eip.cuvalley_eip.public_ip
}
output "cloudfront_id" {
  value = aws_cloudfront_distribution.front.id
}

output "bucket_name" {
  value = aws_s3_bucket.cuvalley-front.id
}