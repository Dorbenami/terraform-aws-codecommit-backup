output "repository_name" {
  value = aws_codecommit_repository.repo.repository_name
}

output "repository_arn" {
  value = aws_codecommit_repository.repo.arn
}

# Output repository details for use in automation
output "repository_clone_url_http" {
  value = aws_codecommit_repository.repo.clone_url_http
}
