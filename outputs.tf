output "bucket_name" {
  value = module.s3_bucket.bucket_name
}

output "instance_id" {
  value = module.ec2_instance.instance_id
}

output "public_ip" {
  value = module.ec2_instance.public_ip
}

