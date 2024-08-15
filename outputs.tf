output "bucket_arn" {
  value       = module.s3_bucket.bucket_arn
  description = "The ARN of the S3 bucket"
}

output "external_volume_aws_iam_user_arn" {
  value       = module.snowflake_volume.external_volume_aws_iam_user_arn
  description = "The ARN of the IAM User that has access to the S3 bucket"
}
