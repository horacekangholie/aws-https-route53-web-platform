data "aws_route53_zone" "this" {
  name         = var.domain_name
  private_zone = false
}

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

  dvo_map = {
    for dvo in var.certificate_domain_validation_options :
    dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }
}

resource "aws_route53_record" "acm_validation" {
  for_each = local.dvo_map

  zone_id = data.aws_route53_zone.this.zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = 60
  records = [each.value.record]
  allow_overwrite = true
}

resource "aws_acm_certificate_validation" "this" {
  certificate_arn         = var.certificate_arn
  validation_record_fqdns = [for r in aws_route53_record.acm_validation : r.fqdn]
}

resource "aws_route53_record" "app_alias" {
  zone_id = data.aws_route53_zone.this.zone_id
  name    = "${var.record_name}.${var.domain_name}"
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}