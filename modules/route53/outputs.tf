output "hosted_zone_id" {
  value = data.aws_route53_zone.this.zone_id
}

output "validated_certificate_arn" {
  value = aws_acm_certificate_validation.this.certificate_arn
}

output "application_fqdn" {
  value = aws_route53_record.app_alias.fqdn
}