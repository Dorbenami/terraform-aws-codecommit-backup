variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "expiration_days" {
  description = "Number of days before backups expire"
  type        = number
  default     = 30
}

variable "repository_name" {
  description = "Name of the CodeCommit repository"
  type        = string
}

variable "repository_description" {
  description = "Description of the CodeCommit repository"
  type        = string
  default     = "A repository for storing code to back up"
}

variable "pipeline_name" {
  description = "Name of the CodePipeline"
  type        = string
}

variable "branch_name" {
  description = "Branch name for the repository"
  type        = string
  default     = "main"
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "account_id" {
  description = "AWS account ID"
  type        = string
}
