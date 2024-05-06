# terraform script to create a worker node and security group in us-east-1

locals {
ami_id = "ami-080e1f13689e07408"
vpc_id = "vpc-00ad6a223561e5e0d"
ssh_user = "ubuntu"
key_name = "keypair"
private_key_path = "/home/labsuser/ansible/keypair"
}
# provider details

provider "aws" {
    region = "us-east-1" 
}

# aws security resource group

resource "aws_security_group" "access" {
    name = "projectaccess"
    vpc_id = local.vpc_id

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        }

     ingress {
        from_port = 80
        to_port   = 80
        protocol =  "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        }      

      egress {
         from_port = 0
         to_port = 0
         protocol = "-1"
         cidr_blocks = ["0.0.0.0/0"]
         }
}

# aws instance resource block

resource "aws_instance" "project1" {
          ami = local.ami_id
          instance_type   = "t2.micro"
          associate_public_ip_address = true
          vpc_security_group_ids = [aws_security_group.access.id] 
          key_name = local.key_name
          tags= {
             name= "worker-node"
             }
}
