# modules/listener/output.tf
output "https_listener_arn" {
  description = "ARN of the HTTPS listener"
  value       = aws_lb_listener.https.arn
}

output "https_listener_rule_arn" {
  description = "ARN of the HTTPS listener rule"
  value       = aws_lb_listener_rule.https_host_header.arn
}

output "https_record_fqdn" {
  description = "FQDN of the Route53 record"
  value       = aws_route53_record.https_record.fqdn
}
