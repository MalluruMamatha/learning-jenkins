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
    }
  ]

  
}
