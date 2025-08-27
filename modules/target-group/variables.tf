# modules/target-group/variables.tf
variable "target_group_name" {
  description = "Name of the target group"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the target group will be created"
  type        = string
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}
