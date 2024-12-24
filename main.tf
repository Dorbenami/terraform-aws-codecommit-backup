module "s3_bucket" {
  source          = "./modules/s3_bucket"
  bucket_name     = "my-codecommit-backups"
  expiration_days = 30
}

module "codecommit" {
  source          = "./modules/codecommit"
  repository_name = "example-repo"
  description     = "A repository for storing code to back up"
}

module "iam" {
  source = "./modules/iam"

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

  policy_document = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "codecommit:GetBranch",
          "codecommit:GetCommit",
          "codecommit:UploadArchive",
          "codecommit:GetUploadArchiveStatus",
          "codecommit:CancelUploadArchive",
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket"
        ],
        Resource = [
          "arn:aws:codecommit:il-central-1:381492011511:example-repo",
          "arn:aws:s3:::my-codecommit-backups",
          "arn:aws:s3:::my-codecommit-backups/*"
        ]
      }
    ]
  })
}


module "codepipeline" {
  source          = "./modules/codepipeline"
  pipeline_name   = "codecommit-backup-pipeline"
  role_arn        = module.iam.role_arn
  bucket_name     = module.s3_bucket.bucket_name
  repository_name = module.codecommit.repository_name
  branch_name     = "main"
}


