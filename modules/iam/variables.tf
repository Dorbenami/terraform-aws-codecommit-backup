variable "assume_role_policy" {
  description = "Assume role policy document"
  type        = string
}

variable "policy_document" {
  description = "Policy document for CodePipeline"
  type        = string
}
