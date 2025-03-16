# Output EC2 instance ID
output "ec2_instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.secure_ubuntu.id
}

# Output Dev User's access key
output "dev_user_access_key" {
  description = "Access key for the Dev User"
  value       = aws_iam_access_key.dev_user_access_key.id
  sensitive   = true
}

# Output Dev User's secret access key
output "dev_user_secret_key" {
  description = "Secret access key for the Dev User"
  value       = aws_iam_access_key.dev_user_access_key.secret
  sensitive   = true
}

