variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "private_app_subnet_ids" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

variable "target_group_arn" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "root_volume_size_gb" {
  type = number
}

variable "enable_detailed_monitoring" {
  type = bool
}

variable "ec2_ami_ssm_parameter" {
  type = string
}

variable "asg_min_size" {
  type = number
}

variable "asg_desired_capacity" {
  type = number
}

variable "asg_max_size" {
  type = number
}

variable "user_data_template_path" {
  type = string
}

variable "common_tags" {
  type = map(string)
}