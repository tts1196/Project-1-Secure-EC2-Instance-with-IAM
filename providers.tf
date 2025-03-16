terraform {
  backend "remote" {
    organization = "Home_Labs_xvi" # Replace with your Terraform Cloud organization name

    workspaces {
      name = "Week_1_Provision_a_Secure_EC2_Instance" # Replace with your Terraform Cloud workspace name
    }
  }
}

provider "aws" {
  # profile = "master-user"
  region = var.region
}