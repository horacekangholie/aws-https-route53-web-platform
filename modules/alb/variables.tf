variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "app_security_group_id" {
  type = string
}

variable "health_check_path" {
  type = string
}

variable "certificate_arn" {
  type = string
}

variable "allowed_http_cidrs" {
  type = list(string)
}

variable "common_tags" {
  type = map(string)
}