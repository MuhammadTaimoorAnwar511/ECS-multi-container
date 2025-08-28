output "certificate_arn" {
  description = "ARN of the ACM certificate"
  value       = try(aws_acm_certificate.this[0].arn, null)
}

output "certificate_domain" {
  description = "Domain name on the ACM certificate"
  value       = try(aws_acm_certificate.this[0].domain_name, null)
}

output "certificate_validation_status" {
  description = "Validation status of the ACM certificate"
  value       = try(aws_acm_certificate.this[0].status, null)
}
