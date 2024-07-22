data "aws_ami" "ami_info" {
  most_recent      = true
   
  
    filter {
    name   = "name"
    values = ["RHEL-9-DevOps-Practice"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
 filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }
  
}


# data "aws_security_groups" "sg_id" {
#   filter {
#     name   = "name"
#     values = ["allow-everything"]
#   }

  
# }

data "aws_ami" "nexus_ami_info" {

    most_recent = true
    owners = ["679593333241"]

    filter {
        name   = "name"
        values = ["SolveDevOps-Nexus-Server-Ubuntu20.04-20240511-*"]
    }

    filter {
        name   = "root-device-type"
        values = ["ebs"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }
}