variable "domain_name" {
  type = string
}

variable "record_name" {
  type = string
}

variable "alb_dns_name" {
  type = string
}

variable "alb_zone_id" {
  type = string
}

variable "certificate_domain_validation_options" {
  type = any
}

variable "certificate_arn" {
  type = string
}

variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "common_tags" {
  type = map(string)
}