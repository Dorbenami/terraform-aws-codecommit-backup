variable "bucket_name" {
  description = "Name of the S3 bucket for CodePipeline artifacts"
  type        = string
}

variable "expiration_days" {
  description = "Number of days to retain artifacts in the S3 bucket"
  type        = number
}

variable "repository_version" {
  description = "Versioning configuration for the repository"
  type        = string
}

variable "region" {
  description = "AWS Region"
  type        = string
}

variable "account_id" {
  description = "AWS Account ID"
  type        = string
}

variable "repositories" {
  description = "Map of repositories and their branches"
  type        = map(list(string))
  default = {
    "repo-one" = ["feature1", "feature2", "bugfix1", "release", "main"]
    "repo-two" = ["dev", "staging", "prod", "hotfix", "test"]
  }
}
