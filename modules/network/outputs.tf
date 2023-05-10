output "public_subnet_id" {
    value = aws_subnet.public_subnet.id
}
output "vpc_id" {
    value = aws_vpc.jenkins_vpc.id
}
output "jenkins_sg" {
    value = aws_security_group.jenkins_firewall.id
}
output "jenkins_eip" {
    value = aws_eip.jenkins_eip.public_ip
}
output "project_name" {
  value = var.project_name
}