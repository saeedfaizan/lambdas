terraform {
  source = "${get_repo_root()}/infrastructure/modules//bootstrap"
}

include "root" {
  path   = find_in_parent_folders()
  expose = true
}

inputs = {
  github_repository_name = include.root.locals.repo_name
}