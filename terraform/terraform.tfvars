misp_cicd_vars = {
  region        = "us-east-1"
  vpc           = "vpc-VPC_ID"
  ami           = "ami-AMI_ID"
  instance_type = "t2.micro"
  subnet        = "subnet-SUBNET_ID"
  public_ip     = true
  secgroupname  = "misp_cicd_securitygroup"
}

homelab_vars = {
  cidr_blocks = ["CIDR_HOMELAB"]
}
