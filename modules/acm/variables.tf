
variable "create_acm" {
  description = "Whether to create ACM Certificate and Route53 validation records. Set to false to skip creation."
  type        = bool
  default     = true
}
variable "domain_name" {
  description = "Fully qualified domain name (FQDN) for the ACM certificate"
  type        = string
}
variable "hosted_zone_id" {
  description = "Route53 Hosted Zone ID for domain validation"
  type        = string
}
variable "environment" {
  description = "Environment tag (e.g., dev, staging, prod)"
  type        = string
}
variable "owner" {
  description = "Owner tag"
  type        = string
}
variable "tags" {
  description = "Additional tags"
  type        = map(string)
  default     = {}
}
