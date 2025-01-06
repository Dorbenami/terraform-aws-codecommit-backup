variable "role_name" {
  description = "The name of the IAM role for CodePipeline"
  type        = string
}

variable "policy_name" {
  description = "The name of the IAM policy for CodePipeline"
  type        = string
}

variable "assume_role_policy" {
  description = "The assume role policy document"
  type        = string
}

variable "policy_document" {
  description = "The IAM policy document"
  type        = string
}
