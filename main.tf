locals {
  env = terraform.workspace
}

module "s3_bucket" {
  source      = "./modules/s3"
  bucket_name = var.bucket_name
  environment = local.env
}

module "ec2_instance" {
  source        = "./modules/ec2"
  name          = "${local.env}-ec2"
  environment   = local.env
  ami_id        = var.ami_id
  instance_type = var.instance_type
}

