// AWS Variables

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

// S3 Bucket Variables

variable "s3_bucket_name" {
  type        = string
  description = "The name of the Featureform S3 bucket used for storing Snowflake data"
}

// IAM Variables

variable "iam_role_name" {
  type        = string
  description = "The name of the IAM role used by the Snowflake External Volume"
}

variable "iam_policy_name" {
  type        = string
  description = "The name of the IAM policy used by the Snowflake External Volume"
}

variable "iam_external_id" {
  type        = string
  description = "The external ID is used to grant access to your AWS resources (such as S3 buckets) to a third party like Snowflake"
}

variable "iam_user_arn" {
  type        = string
  description = "The AWS IAM user created for your Snowflake account when creating the external volume"
  default     = null
}

// Snowflake Variables

variable "snowflake_role" {
  type        = string
  description = "The name of the Snowflake Role used by the Snowflake External Volume"
  default     = "ACCOUNTADMIN"
}

variable "snowflake_database" {
  type        = string
  description = "The name of the Snowflake Database in which you want to create the External Volume"
}

variable "snowflake_schema" {
  type        = string
  description = "The name of the Snowflake Schema in which you want to create the External Volume"
  default     = "PUBLIC"
}

variable "snowflake_warehouse" {
  type        = string
  description = "The name of the Snowflake Warehouse in which you want to create the External Volume"
}

variable "snowflake_volume_name" {
  type        = string
  description = "The name of the Snowflake External Volume"
}

variable "snowflake_region" {
  type        = string
  description = "The Snowflake region in which you want to create the External Volume (e.g. us-west-2.aws)"
}

variable "snowflake_user" {
  type        = string
  description = "The service user name created for programmatic access to Snowflake"
}

variable "snowflake_account" {
  type        = string
  description = "value of the Snowflake account (e.g. <ORG ID>-<ACCOUNT ID>)"
}

variable "snowflake_private_key_path" {
  type        = string
  description = "The path to the private key file used to authenticate with Snowflake (e.g. /Users/<username>/.ssh/snowflake_tf.p8)"
}
