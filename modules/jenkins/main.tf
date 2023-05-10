resource "tls_private_key" "private_key" {
    algorithm = "RSA"
    rsa_bits = 4096
}

resource "aws_key_pair" "jenkins_key_pair" {
    key_name = "jenkins-key"
    public_key = tls_private_key.private_key.public_key_openssh
    depends_on = [ tls_private_key.private_key ]
}

resource "local_file" "save_key_jenkins" {
    content = tls_private_key.private_key.private_key_pem
    filename = "jenkins-key.pem"
}

data "aws_ami" "ubuntu" {
    most_recent = true
    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }

    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }

    owners = ["099720109477"]
  
}

resource "aws_instance" "jenkins_server" {
    ami = data.aws_ami.ubuntu.id
    subnet_id = var.public_subnet
    instance_type = var.instance_type
    vpc_security_group_ids = [ var.jenkins_sg ]
    key_name = aws_key_pair.jenkins_key_pair.key_name
    user_data = file("./jenkins.sh")
    tags = {
      Name = "${var.project_name}-server"
    }
}