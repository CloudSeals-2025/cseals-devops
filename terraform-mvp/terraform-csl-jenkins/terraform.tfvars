region               = "us-east-1"
vpc_cidr             = "11.0.0.0/16"
vpc_name             = "project-vpc-1"
cidr_public_subnet   = ["11.0.1.0/24", "11.0.2.0/24"]
cidr_private_subnet  = ["11.0.3.0/24", "11.0.4.0/24"]
us_availability_zone = ["us-east-1a", "us-east-1b"]
ec2_ami_id           = "ami-00a929b66ed6e0de6"