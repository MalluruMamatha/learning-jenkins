#### Jenkins Master Creation

module "jenkins" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "jenkins-master"

  instance_type          = "t3.small"
  ami = data.aws_ami.ami_info.id
  vpc_security_group_ids = ["sg-02b9c227b04592725"]
  subnet_id              = "subnet-05957263b02ce2391"
  user_data = file("jenkins.sh")

  tags = {

    Name = "jenkins-master"
  }

} 


  
module "jenkins_agent" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "jenkins-agent"

  instance_type          = "t3.small"
  ami = data.aws_ami.ami_info.id
  vpc_security_group_ids = ["sg-02b9c227b04592725"]
  subnet_id = "subnet-05957263b02ce2391"
  user_data = file("jenkins-agent.sh")

  tags = {

    Name = "jenkins-agent"
  }

} 

resource "aws_key_pair" "nexus" {
  key_name   = "nexus"
  #public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAAj+LuGH97RBcpUk7yrNkh964sqB0Az2yjzyCW3gdJW Mammu@DESKTOP-AUVJB9I"
  public_key = file("~/.ssh/nexus.pub")

  ### you can give the pub key or else pub key file path here

}


module "nexus" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "nexus"

  instance_type          = "t3.medium"
  ami = data.aws_ami.nexus_ami_info.id
  vpc_security_group_ids = ["sg-02b9c227b04592725"]  
  subnet_id = "subnet-05957263b02ce2391"
  key_name = aws_key_pair.nexus.key_name
  root_block_device = [
    {
      volume_type = "gp3"
      volume_size = 30
    }
  ]

  tags = {

    Name = "nexus"
  }

} 

  module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 3.0"

zone_name = var.zone_name

  records = [
 
    {
      name    = "jenkins"
      type    = "A"
      ttl     = 1
      records = [
        module.jenkins.public_ip
      ]
       allow_overwrite = true
    },

    {
      name    = "jenkins-agent"
      type    = "A"
      ttl     = 1
      records = [
        module.jenkins_agent.private_ip
      ]
       allow_overwrite = true
    },
    {
      name    = "nexus"
      type    = "A"
      ttl     = 1
      records = [
        module.nexus.private_ip
      ]
       allow_overwrite = true
    }
  ]

  
}
