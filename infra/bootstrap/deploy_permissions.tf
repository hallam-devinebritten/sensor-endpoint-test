data "aws_iam_policy_document" "deploy_state_access" {
  for_each = var.enviroments

  statement {
    sid       = "ListStateBucket"
    actions   = ["s3:ListBucket"]
    resources = [aws_s3_bucket.state.arn]
  }


  statement {
    sid       = "ReadWriteOwnStateOnly"
    actions   = ["s3:getObject", "s3:PutObject", "s3:DeleteObject"]
    resources = ["${aws_s3_bucket.state.arn}/${each.key}/*"]

  }
}

resource "aws_iam_role_policy" "deploy_state_access" {
  for_each = var.enviroments

  name   = "terraform-state-access"
  role   = aws_iam_role.deploy[each.key].id
  policy = data.aws_iam_policy_document.deploy_state_access[each.key].json
}