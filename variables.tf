variable "region" {
  description = "AWS region"
  type        = string
}

variable "key_name" {
  description = "EC2 Key Pair name for SSH"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "ec2_tag" {
  description = "Name tag for EC2 instance"
  type        = string
}