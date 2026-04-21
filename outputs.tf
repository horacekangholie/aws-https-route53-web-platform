output "application_url" {
  description = "Application HTTPS URL"
  value       = "https://${var.subdomain}.${var.domain_name}"
}

output "alb_dns_name" {
  description = "ALB DNS name"
  value       = module.alb.alb_dns_name
}

output "hosted_zone_id" {
  description = "Route53 hosted zone ID"
  value       = module.route53.hosted_zone_id
}

output "certificate_arn" {
  description = "Issued ACM certificate ARN"
  value       = module.route53.validated_certificate_arn
}

output "autoscaling_group_name" {
  description = "Auto Scaling Group name"
  value       = module.asg.autoscaling_group_name
}