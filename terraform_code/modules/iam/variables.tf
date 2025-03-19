variable "eks_role_name" {
  description = "Name of the EKS cluster IAM role"
  type        = string
}

variable "common_tags" {
  type = map(string)
  default = {
    Env    = "dev"
    Owner  = "atul.pandey@talentica.com"
    System = "CloudOps"
  }
}
