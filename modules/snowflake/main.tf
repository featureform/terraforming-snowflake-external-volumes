terraform {
  required_providers {
    snowflake = {
      source = "snowflake-labs/snowflake"
    }
  }
}

locals {
  volume_name = replace(var.snowflake_volume_name, "-", "_")
}

resource "snowflake_unsafe_execute" "use_database" {
  execute = <<EOT
USE DATABASE ${var.snowflake_database};
EOT

  revert = "SELECT 1;" # No-op revert statement
}

resource "snowflake_unsafe_execute" "use_schema" {
  execute = <<EOT
USE SCHEMA ${var.snowflake_schema};
EOT

  revert = "SELECT 1;" # No-op revert statement

  depends_on = [snowflake_unsafe_execute.use_database]
}

resource "snowflake_unsafe_execute" "iceberg_volume" {
  execute = <<EOT
CREATE OR REPLACE EXTERNAL VOLUME ${local.volume_name}
   STORAGE_LOCATIONS =
      (
         (
            NAME = '${var.s3_bucket_name}',
            STORAGE_PROVIDER = 'S3'
            STORAGE_BASE_URL = 's3://${var.s3_bucket_name}',
            STORAGE_AWS_ROLE_ARN = '${var.iam_storage_role_arn}',
            STORAGE_AWS_EXTERNAL_ID = '${var.iam_external_id}'
         )
      )
EOT

  revert = <<EOT
DROP EXTERNAL VOLUME IF EXISTS ${local.volume_name}
EOT

  query = <<EOT
DESC EXTERNAL VOLUME ${local.volume_name}
EOT

  depends_on = [snowflake_unsafe_execute.use_schema]
}

output "external_volume_aws_iam_user_arn" {
  value = jsondecode(snowflake_unsafe_execute.iceberg_volume.query_results[index(snowflake_unsafe_execute.iceberg_volume.query_results.*.property, "STORAGE_LOCATION_1")].property_value).STORAGE_AWS_IAM_USER_ARN
}
