resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name

  tags = {
    Name = var.bucket_name
  }
}

output "bucket_arn" {
  value = aws_s3_bucket.this.arn
}
