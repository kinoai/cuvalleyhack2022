output "ec2_public_ip" {
  value = aws_eip.cuvalley_eip.public_ip
}