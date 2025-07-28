locals {
  # UPDATE ME
  repo_name = "lambdas"
}

remote_state {
  backend  = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
  config = {
    bucket         = "${get_aws_account_id()}-terragrunt-state"
    key            = "${local.repo_name}/${path_relative_to_include()}/terraform.tfstate"
    region         = "eu-central-1"
    encrypt        = true
    use_lockfile   = true  # Enable S3 native state locking

    s3_bucket_tags = {
      "idealo:information-classes" = "intellectual-property"
      "idealo:data-classification" = "internal-only-data"
    }
  }
}

generate "providers" {
  path      = "providers.tf"
  if_exists = "overwrite_terragrunt"

  # language=HCL
  contents = <<EOF
provider "aws" {
  region = "eu-central-1"
  allowed_account_ids = ["${get_aws_account_id()}"]
}
EOF
}

terraform {
  before_hook "ensure_cache" {
    commands = ["init"]
    execute  = ["mkdir", "-p", "${get_repo_root()}/.terraform-cache"]
  }

  after_hook "multi_arch_lockfile" {
    commands = contains(get_terraform_cli_args(), "-upgrade") || !fileexists("${path_relative_to_include()}/.terraform.lock.hcl") ? ["init"] : []
    working_dir = get_original_terragrunt_dir()
    execute = ["terragrunt", "providers", "lock"]
  }

  after_hook "tflint" {
    commands = ["validate"]
    execute = ["tflint"]
  }

  extra_arguments "tfenv_version" {
    commands = [get_terraform_command()] # always
    env_vars = {
      TFENV_TERRAFORM_VERSION = file("${get_repo_root()}/.terraform-version")
    }
  }

  extra_arguments "cache" {
    commands = concat(["plan", "apply", "destroy"], contains(get_terraform_cli_args(), "-upgrade") ? [] : ["init"])
    env_vars = {
      TF_PLUGIN_CACHE_DIR = "${get_repo_root()}/.terraform-cache"
    }
  }

  extra_arguments "ignore_cache_on_upgrade" {
    commands = contains(get_terraform_cli_args(), "-upgrade") || !fileexists("${path_relative_to_include()}/.terraform.lock.hcl") ? ["init"] : []
    env_vars = {
      TF_PLUGIN_CACHE_DIR = ""
    }
  }

  extra_arguments "add_signatures_for_other_platforms" {
    commands = contains(get_terraform_cli_args(), "lock") ? ["providers"] : []
    # use env_vars since "provider locks" argument order fails
    env_vars = {
      TF_CLI_ARGS_providers_lock = "-platform=darwin_amd64 -platform=darwin_arm64 -platform=linux_amd64"
      TF_PLUGIN_CACHE_DIR = ""
    }
  }
}