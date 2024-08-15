terraform {
  required_providers {
    snowflake = {
      source = "snowflake-labs/snowflake"
    }
  }
}

# AWS Provider
provider "aws" {
  region = var.aws_region
}

# Snowflake Provider
provider "snowflake" {
  account       = var.snowflake_account
  role          = var.snowflake_role
  user          = var.snowflake_user
  authenticator = "JWT"
  private_key   = file(var.snowflake_private_key_path)
  warehouse     = var.snowflake_warehouse
}

# S3 Bucket Module
module "s3_bucket" {
  source      = "./modules/s3"
  bucket_name = var.s3_bucket_name
}

# IAM Module
module "iam" {
  source          = "./modules/iam"
  iam_role_name   = var.iam_role_name
  iam_policy_name = var.iam_policy_name
  s3_bucket_arn   = module.s3_bucket.bucket_arn
  iam_external_id = var.iam_external_id
  iam_user_arn    = var.iam_user_arn
}

module "sts_check_and_enable" {
  source           = "./modules/sts-check"
  snowflake_region = var.snowflake_region
}

# Snowflake External Volume
module "snowflake_volume" {
  source                = "./modules/snowflake"
  snowflake_volume_name = var.snowflake_volume_name
  snowflake_database    = var.snowflake_database
  snowflake_schema      = var.snowflake_schema
  snowflake_warehouse   = var.snowflake_warehouse
  iam_storage_role_arn  = module.iam.iam_role_arn
  s3_bucket_name        = var.s3_bucket_name
  iam_external_id       = var.iam_external_id
}
