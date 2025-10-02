# Output inside the module
output "bucket_name" {
  value = aws_s3_bucket.this.id
}
