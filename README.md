# Featureform: Terraforming Snowflake External Volumes

## Overview

Snowflake's _Tutorial: Create Your First Iceberg Table_ (see [Resources](#resources)) is an excellent primer on the infrastructural prerequisites to creating Apache Iceberg tables; however, it requires readers to access the AWS Management Console and Snowflake SQL Worksheets to correctly configure the external volume.

Given enterprise users are more often than not using an IaC framework, such as Terraform, an IaC example is more relevant and helpful to support users who are deploying Featureform with Snowflake as a data provider.

This repo is a working example of how to use Terraform to create and/or configure the following:

* A dedicated S3 bucket to store Featureform-managed Apache Iceberg tables
* Enabling the STS endpoint for the Snowflake AWS region
* IAM role and policy for the Snowflake external volume
* A Snowflake external volume

## Walkthrough

After running `terraform init`, create `terraform.tfvars` in the root of the project and populate it with the necessary values. You can use the below template to get started:

```text
# AWS CONFIGURATION
aws_region = ""

# S3 BUCKET CONFIGURATION
s3_bucket_name = ""

# IAM CONFIGURATION
iam_role_name   = ""
iam_policy_name = ""
iam_external_id = ""
# Initially empty for the first apply, but will required the output external_volume_aws_iam_user_arn
# to be set for the second apply to properly update the IAM role
# iam_user_arn    = ""

# SNOWFLAKE CONFIGURATION
snowflake_role        = ""
snowflake_database    = ""
snowflake_schema      = ""
snowflake_warehouse   = ""
snowflake_volume_name = ""
# Based on issue 529 (https://github.com/Snowflake-Labs/terraform-provider-snowflake/issues/529), the region required the .aws suffix
snowflake_region           = ""
snowflake_user             = ""
snowflake_account          = ""
snowflake_private_key_path = ""
```

**NOTE**: If you haven't previously created a service user in Snowflake, see _Terraforming Snowflake_ in the [Resources](#resources) to create a service user for programmatic access.

Once you've populate `terraform.tfvars`, run `terraform plan` and verify the output looks correct.

Now run `terraform apply`. The first run of `apply` will create the S3 bucket, the IAM role and policy, and the Snowflake external volume; however, the IAM policy will be missing the AWS IAM user ARN in the trust relationship. To complete this step, take the output value `external_volume_aws_iam_user_arn` and add it to the key `iam_user_arn` in `terraform.tfvars`. Once this is complete, run `terraform apply` again. This second apply will add the AWS IAM user ARN created by Snowflake to the `Principal` second of the trust relationship document.

You can now create Apache Iceberg tables in Snowflake using your newly created external volume.

## Resources

* [Tutorial: Create Your First Iceberg Table](https://docs.snowflake.com/en/user-guide/tutorials/create-your-first-iceberg-table#introduction)
* [Terraforming Snowflake](https://quickstarts.snowflake.com/guide/terraforming_snowflake/#0)
* [Snowflake Terraform Provider](https://github.com/Snowflake-Labs/terraform-provider-snowflake)
* [`snowflake_unsafe_execute` GitHub Gist](https://gist.github.com/prabodh1194/74453c49b053521b0e112388d3a31148)
