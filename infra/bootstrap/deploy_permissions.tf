data "aws_iam_policy_document" "deploy_state_access" {
  for_each = var.environments

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
  for_each = var.environments

  name   = "terraform-state-access"
  role   = aws_iam_role.deploy[each.key].id
  policy = data.aws_iam_policy_document.deploy_state_access[each.key].json
}


locals {
  account_id = data.aws_caller_identity.current.account_id
}

data "aws_iam_policy_document" "deploy_app" {
  for_each = var.environments

  statement {
    sid       = "ManageOwnLambdaFunctions"
    actions   = ["lambda:*"]
    resources = ["arn:aws:lambda:${var.region}:${local.account_id}:function:${var.project}-${each.key}-*"]
  }

  statement {
    sid     = "ManageOwnLogGroups"
    actions = ["logs:*"]
    resources = [
      "arn:aws:logs:${var.region}:${local.account_id}:log-group:/aws/lambda/${var.project}-${each.key}-*",
      "arn:aws:logs:${var.region}:${local.account_id}:log-group:/aws/lambda/${var.project}-${each.key}-*:*",
    ]
  }

  statement {
    sid       = "DescribeLogGroups"
    actions   = ["logs:DescribeLogGroups"]
    resources = ["*"]
  }

  statement {
    sid = "ManageOwnLambdaExecutionRole"
    actions = [
      "iam:CreateRole",
      "iam:DeleteRole",
      "iam:GetRole",
      "iam:UpdateRole",
      "iam:UpdateRoleDescription",
      "iam:UpdateAssumeRolePolicy",
      "iam:TagRole",
      "iam:UntagRole",
      "iam:ListRoleTags",
      "iam:PutRolePolicy",
      "iam:GetRolePolicy",
      "iam:DeleteRolePolicy",
      "iam:ListRolePolicies",
      "iam:ListAttachedRolePolicies",
      "iam:ListInstanceProfilesForRole",
    ]
    resources = ["arn:aws:iam::${local.account_id}:role/${var.project}-${each.key}-lambda"]
  }

  statement {
    sid       = "PassExecutionRoleToLambdaOnly"
    actions   = ["iam:PassRole"]
    resources = ["arn:aws:iam::${local.account_id}:role/${var.project}-${each.key}-lambda"]

    condition {
      test     = "StringEquals"
      variable = "iam:PassedToService"
      values   = ["lambda.amazonaws.com"]
    }
  }

  statement {
    sid     = "ManageHttpApis"
    actions = ["apigateway:GET", "apigateway:POST", "apigateway:PUT", "apigateway:PATCH", "apigateway:DELETE"]
    resources = [
      "arn:aws:apigateway:${var.region}::/apis",
      "arn:aws:apigateway:${var.region}::/apis/*",
      "arn:aws:apigateway:${var.region}::/tags/*",
    ]
  }
}

resource "aws_iam_role_policy" "deploy_app" {
  for_each = var.environments

  name   = "manage-own-app-resources"
  role   = aws_iam_role.deploy[each.key].id
  policy = data.aws_iam_policy_document.deploy_app[each.key].json
}