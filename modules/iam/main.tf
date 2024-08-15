resource "aws_iam_role" "this" {
  name = var.iam_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      merge(
        {
          Action = "sts:AssumeRole",
          Effect = "Allow",

          Condition = {
            StringEquals = {
              "sts:ExternalId" = var.iam_external_id
            }
          }
        },
        coalesce(var.iam_user_arn == null ?
          {
            Principal = {
              Service = "s3.amazonaws.com"
            }
            } : {
            Principal = {
              AWS = var.iam_user_arn
            }

        })
      )
    ],
  })
}

resource "aws_iam_policy" "this" {
  name        = var.iam_policy_name
  description = "IAM policy for ${var.iam_role_name}"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:DeleteObject",
          "s3:DeleteObjectVersion",
        ],
        Resource = "${var.s3_bucket_arn}/*",
      },
      {
        Effect = "Allow",
        Action = [
          "s3:ListBucket",
          "s3:GetBucketLocation",
        ],
        Resource = var.s3_bucket_arn,
        Condition = {
          StringLike = {
            "s3:prefix" : [
              "*"
            ]
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}

output "iam_role_arn" {
  value = aws_iam_role.this.arn
}

output "iam_policy_arn" {
  value = aws_iam_policy.this.arn
}
