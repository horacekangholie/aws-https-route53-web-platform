locals {
  fqdn = "${var.subdomain}.${var.domain_name}"
}

module "vpc" {
  source = "./modules/vpc"

  project_name               = var.project_name
  environment                = var.environment
  vpc_cidr                   = var.vpc_cidr
  public_subnet_cidrs        = var.public_subnet_cidrs
  private_app_subnet_cidrs   = var.private_app_subnet_cidrs
  common_tags                = var.common_tags
}

module "acm" {
  source = "./modules/acm"

  domain_name  = local.fqdn
  project_name = var.project_name
  environment  = var.environment
  common_tags  = var.common_tags
}

module "route53" {
  source = "./modules/route53"

  domain_name                = var.domain_name
  record_name                = var.subdomain
  alb_dns_name               = module.alb.alb_dns_name
  alb_zone_id                = module.alb.alb_zone_id
  certificate_domain_validation_options = module.acm.domain_validation_options
  certificate_arn            = module.acm.certificate_arn
  project_name               = var.project_name
  environment                = var.environment
  common_tags                = var.common_tags
}

module "alb" {
  source = "./modules/alb"

  project_name             = var.project_name
  environment              = var.environment
  vpc_id                   = module.vpc.vpc_id
  public_subnet_ids        = module.vpc.public_subnet_ids
  app_security_group_id    = module.asg.app_security_group_id
  health_check_path        = var.health_check_path
  certificate_arn          = module.route53.validated_certificate_arn
  allowed_http_cidrs       = var.allowed_http_cidrs
  common_tags              = var.common_tags
}

module "asg" {
  source = "./modules/asg"

  project_name               = var.project_name
  environment                = var.environment
  private_app_subnet_ids     = module.vpc.private_app_subnet_ids
  vpc_id                     = module.vpc.vpc_id
  target_group_arn           = module.alb.target_group_arn
  instance_type              = var.instance_type
  root_volume_size_gb        = var.root_volume_size_gb
  enable_detailed_monitoring = var.enable_detailed_monitoring
  ec2_ami_ssm_parameter      = var.ec2_ami_ssm_parameter
  asg_min_size               = var.asg_min_size
  asg_desired_capacity       = var.asg_desired_capacity
  asg_max_size               = var.asg_max_size
  user_data_template_path    = "${path.module}/user_data.sh.tpl"
  common_tags                = var.common_tags
}