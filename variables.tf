# AWS region where resources will be deployed
variable "region" {
  description = "AWS region to deploy resources"
  default     = "ap-northeast-1" # Replace with your preferred region
}

# AMI ID for Ubuntu 22.04
variable "ami_id" {
  description = "AMI ID for Ubuntu 22.04"
  default     = "ami-0a290015b99140cd1" # Replace with your region's valid AMI ID
}

# Instance type for EC2
variable "instance_type" {
  description = "Type of the EC2 instance"
  default     = "t2.micro" # Free-tier eligible instance type
}

