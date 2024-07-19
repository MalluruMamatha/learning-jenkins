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