output "role_arn" {
  description = "The ARN of the IAM role"
  value       = aws_iam_role.codepipeline_role.arn
}

output "policy_document_debug" {
  value = var.policy_document
}