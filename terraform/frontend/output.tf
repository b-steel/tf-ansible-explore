output "remix_frontend_public_ip" {
  description = "the public ip of the fronend"
  value = aws_instance.remix-frontend.public_ip
}
