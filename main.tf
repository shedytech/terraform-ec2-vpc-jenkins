module "vpc" {
  source = "./modules/vpc"
}

module "ec2" {
  source        = "./modules/ec2"
  subnet_id     = module.vpc.public_subnet_id
  vpc_id        = module.vpc.vpc_id
  ami           = "ami-0fc5d935ebf8bc3bc"
  instance_type = var.instance_type
  key_name      = var.key_name
  ec2_tag       = var.ec2_tag
}