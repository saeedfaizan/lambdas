terraform {
  required_version = "~> 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

module "terraform_execution_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "~> 5.9"

  create_role          = true
  role_name            = "${var.github_repository_name}-terraform"
  max_session_duration = 6 * 60 * 60

  provider_url                 = "token.actions.githubusercontent.com"
  # see also https://confluence.idealo.tools/display/SEC/iam_role_administratoraccess_policy_permissive_trust_relationship "Hint for users of Terraform"
  oidc_fully_qualified_audiences = ["sts.amazonaws.com"]
  oidc_subjects_with_wildcards = [
    "repo:${var.github_repository_owner}/${var.github_repository_name}:*"
  ]

  role_policy_arns = [
    "arn:aws:iam::aws:policy/AdministratorAccess",
  ]
  number_of_role_policy_arns = 1
}