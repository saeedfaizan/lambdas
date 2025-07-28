variable "github_repository_owner" {
  description = "The owner of the GitHub repository (e.g. idealo) that this bootstrapping is for."
  type = string
  default = "idealo"
}

variable "github_repository_name" {
  description = "The name of the GitHub repository that this bootstrapping is for."
  type = string
}