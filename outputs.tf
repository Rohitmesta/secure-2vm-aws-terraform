output "vpc_id" {
  value = aws_vpc.lab.id
}

output "public_subnet_id" {
  value = aws_subnet.public.id
}

output "private_subnet_id" {
  value = aws_subnet.private.id
}

output "windows_public_ip" {
  value = aws_instance.windows_jump.public_ip
}

output "windows_private_ip" {
  value = aws_instance.windows_jump.private_ip
}

output "linux_private_ip" {
  value = aws_instance.linux_private.private_ip
}

output "linux_public_ip" {
  value = aws_instance.linux_private.public_ip
}
