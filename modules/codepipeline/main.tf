resource "aws_codepipeline" "pipeline" {
  name     = var.pipeline_name
  role_arn = var.role_arn

  artifact_store {
    type     = "S3"
    location = var.bucket_name
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["source_output"]
      configuration = {
        RepositoryName = var.repository_name
        BranchName     = var.branch_name
      }
    }
  }

  stage {
    name = "Backup"

    action {
      name            = "BackupToS3"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "S3"
      version         = "1"
      input_artifacts = ["source_output"]
      configuration = {
        BucketName = var.bucket_name
        Extract    = "false"
        ObjectKey  = "backups/${var.repository_name}.zip" # Specify the object key

      }
    }
  }
}
