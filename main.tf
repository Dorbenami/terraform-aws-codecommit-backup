
# S3 Bucket for Pipeline Artifacts
module "s3_bucket" {
  source             = "./modules/s3_bucket"
  bucket_name        = var.bucket_name
  expiration_days    = var.expiration_days
  repository_version = var.repository_version
}

# IAM Role and Policy for CodePipeline
module "iam" {
  source = "./modules/iam"

  role_name   = "codepipeline-role"
  policy_name = "codepipeline-policy"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "codepipeline.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })

  # Generate the policy document explicitly for readability and simplicity
  policy_document = jsonencode({
    Version = "2012-10-17",
    Statement = concat(
      # CodeCommit Permissions
      [
        {
          Effect = "Allow",
          Action = [
            "codecommit:GetBranch",
            "codecommit:GetCommit",
            "codecommit:UploadArchive",
            "codecommit:GetUploadArchiveStatus",
            "codecommit:CancelUploadArchive"
          ],
          Resource = [
            for repo_name, _ in var.repositories : "arn:aws:codecommit:${var.region}:${var.account_id}:${repo_name}"
          ]
        }
      ],
      # S3 General Bucket Access Permissions
      [
        {
          Effect = "Allow",
          Action = [
            "s3:PutObject",
            "s3:GetObject",
            "s3:ListBucket",
            "s3:GetBucketLocation",
            "s3:PutBucketPolicy"
          ],
          Resource = [
            "arn:aws:s3:::${var.bucket_name}",
            "arn:aws:s3:::${var.bucket_name}/*"
          ]
        }
      ],
      # S3 Branch-Specific Paths Permissions
      [
        for repo_name, branches in var.repositories : {
          Effect = "Allow",
          Action = [
            "s3:PutObject",
            "s3:GetObject",
            "s3:ListBucket"
          ],
          Resource = [
            for branch in branches : "arn:aws:s3:::${var.bucket_name}/${repo_name}/${branch}/*"
          ]
        }
      ],
      # Logs Permissions
      [
        {
          Effect = "Allow",
          Action = "logs:*",
          Resource = [
            "arn:aws:logs:${var.region}:${var.account_id}:log-group:/aws/codebuild/*",
            "arn:aws:logs:${var.region}:${var.account_id}:log-group:/aws/lambda/*"
          ]
        }
      ],
      # CodePipeline Execution Permissions
      [
        {
          Effect = "Allow",
          Action = [
            "codepipeline:StartPipelineExecution",
            "codepipeline:GetPipeline",
            "codepipeline:GetPipelineExecution",
            "codepipeline:GetPipelineState",
            "codepipeline:ListActionExecutions"
          ],
          Resource = "*"
        }
      ]
    )
  })
}




# Data Source for Repositories
data "aws_codecommit_repository" "all_repos" {
  for_each        = tomap(var.repositories)
  repository_name = each.key
}


locals {
  pipelines = {
    for idx, pipeline in flatten([
      for repo_name, branches in var.repositories : [
        for branch in branches : {
          repo_name = repo_name
          branch    = branch
        }
      ]
    ]) : "${pipeline.repo_name}-${pipeline.branch}" => pipeline
  }
}

# Dynamic CodePipeline Creation
module "pipelines" {
  for_each = local.pipelines

  source          = "./modules/codepipeline"
  pipeline_name   = replace("${each.value.repo_name}-${each.value.branch}", "/", "-")
  role_arn        = module.iam.role_arn
  bucket_name     = module.s3_bucket.bucket_name
  artifact_path   = "${each.value.repo_name}/${each.value.branch}"
  repository_name = data.aws_codecommit_repository.all_repos[each.value.repo_name].repository_name
  branch_name     = each.value.branch
}

