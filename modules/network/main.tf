data "aws_availability_zones" "available" {
    state = "available"
}
resource "aws_vpc" "jenkins_vpc" {
    cidr_block = var.vpc_cidr
    enable_dns_hostnames = true
    enable_dns_support = true
    tags = {
      Name = "${var.project_name}-VPC"
    }
}

resource "aws_internet_gateway" "jenkins_gw" {
    vpc_id = aws_vpc.jenkins_vpc.id
    tags = {
      Name = "${var.project_name}-IGW"
    }
}

resource "aws_subnet" "public_subnet" {
    vpc_id = aws_vpc.jenkins_vpc.id
    cidr_block = var.public_cidr
    availability_zone = data.aws_availability_zones.available.names[0]
    tags = {
      Name = "${var.project_name}-PUBsubnet"
    }
}

resource "aws_route_table" "public_route" {
    vpc_id = aws_vpc.jenkins_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.jenkins_gw.id
    }
    tags = {
      Name = "${var.project_name}-publicRT"
    }
}

resource "aws_route_table_association" "public_association" {
    subnet_id = aws_subnet.public_subnet.id
    route_table_id = aws_route_table.public_route.id
}

resource "aws_security_group" "jenkins_firewall" {
    vpc_id = aws_vpc.jenkins_vpc.id
    name = "jenkins firewall rules"
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["${var.my_ip}/32"]
    }
    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
  tags = {
    Name = "${var.project_name}-SG"
  }
}