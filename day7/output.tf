output "public_instance_id" {
  value = aws_instance.public.id
}

output "private_instance_id" {
  value = aws_instance.private.id
}

output "public_instance_public_ip" {
  value = aws_instance.public.public_ip
}

output "private_subnet_id" {
  value = aws_subnet.private1.id
}


