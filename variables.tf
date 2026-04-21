variable "project_name" {
  description = "Project name."
  type        = string
  default     = "production-web-platform"
}

variable "environment" {
  description = "Environment name."
  type        = string
  default     = "dev"
}

variable "aws_region" {
  description = "AWS region for deployment."
  type        = string
  default     = "ap-southeast-1"
}

variable "domain_name" {
  description = "Root domain already hosted in Route53, e.g. example.com"
  type        = string
}

variable "subdomain" {
  description = "Subdomain for the application."
  type        = string
  default     = "app"
}

variable "vpc_cidr" {
  description = "VPC CIDR."
  type        = string
  default     = "10.30.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "Two public subnet CIDRs."
  type        = list(string)
  default     = ["10.30.1.0/24", "10.30.2.0/24"]
}

variable "private_app_subnet_cidrs" {
  description = "Two private app subnet CIDRs."
  type        = list(string)
  default     = ["10.30.11.0/24", "10.30.12.0/24"]
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t3.micro"
}

variable "root_volume_size_gb" {
  description = "Root EBS volume size."
  type        = number
  default     = 8
}

variable "enable_detailed_monitoring" {
  description = "Enable EC2 detailed monitoring."
  type        = bool
  default     = false
}

variable "allowed_http_cidrs" {
  description = "CIDRs allowed to reach ALB."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "ec2_ami_ssm_parameter" {
  description = "SSM parameter path for Amazon Linux 2023 AMI."
  type        = string
  default     = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

variable "asg_min_size" {
  description = "ASG minimum size."
  type        = number
  default     = 2
}

variable "asg_desired_capacity" {
  description = "ASG desired capacity."
  type        = number
  default     = 2
}

variable "asg_max_size" {
  description = "ASG maximum size."
  type        = number
  default     = 4
}

variable "health_check_path" {
  description = "ALB health check path."
  type        = string
  default     = "/"
}

variable "common_tags" {
  description = "Common tags."
  type        = map(string)
  default = {
    Owner       = "Horace"
    ManagedBy   = "Terraform"
    Portfolio   = "true"
    ProjectTier = "advanced"
  }
}