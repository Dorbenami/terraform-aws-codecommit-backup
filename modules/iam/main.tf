resource "aws_iam_role" "codepipeline_role" {
  name               = "codepipeline-role"
  assume_role_policy = var.assume_role_policy
}

resource "aws_iam_policy" "codepipeline_policy" {
  name   = "codepipeline-policy"
  policy = var.policy_document
}

resource "aws_iam_role_policy_attachment" "role_policy_attachment" {
  role       = aws_iam_role.codepipeline_role.name
  policy_arn = aws_iam_policy.codepipeline_policy.arn
}


