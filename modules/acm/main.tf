locals {
  name_prefix = "${var.project_name}-${var.environment}"
  tags = merge(
    {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
    },
    var.common_tags
  )
}

resource "aws_acm_certificate" "this" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-acm"
  })

  lifecycle {
    create_before_destroy = true
  }
}