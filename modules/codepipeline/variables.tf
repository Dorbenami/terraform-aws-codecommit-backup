variable "pipeline_name" {
  description = "The name of the CodePipeline"
  type        = string
}

variable "role_arn" {
  description = "IAM Role ARN for CodePipeline"
  type        = string
}

variable "bucket_name" {
  description = "Name of the S3 bucket for pipeline artifacts"
  type        = string
}

variable "repository_name" {
  description = "Name of the CodeCommit repository"
  type        = string
}

variable "branch_name" {
  description = "Branch name to monitor for changes"
  type        = string
}

variable "artifact_path" {
  description = "Path for saving pipeline artifacts in the S3 bucket"
  type        = string
}
