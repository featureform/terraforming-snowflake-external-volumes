locals {
  region = replace(var.snowflake_region, ".aws", "")
}

resource "null_resource" "enable_sts" {
  provisioner "local-exec" {
    command = <<EOT
    aws sts get-caller-identity --region ${local.region} || aws configure set region ${local.region} sts_regional_endpoints enabled
    EOT
  }

  triggers = {
    region = local.region
  }
}
