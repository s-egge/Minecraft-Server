output "instance_public_ip" {
  value = aws_eip.minecraft_eip.public_ip
}