# IAM user for a developer
resource "aws_iam_user" "dev_user" {
  name = "DevUser"
}

# Attach a policy for SSM and EC2 access
resource "aws_iam_user_policy" "dev_user_policy" {
  name = "DevUserPolicy"
  user = aws_iam_user.dev_user.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ssm:StartSession",      # Start an SSM session
          "ssm:DescribeSessions",  # Describe active sessions
          "ssm:TerminateSession",  # Terminate sessions
          "ec2:DescribeInstances", # View EC2 instances
          "ec2:DescribeTags"       # View instance tags
        ],
        Resource = "*" # Allow all resources for simplicity (restrict later in production)
      }
    ]
  })
}

# Generate access keys for the Dev User
resource "aws_iam_access_key" "dev_user_access_key" {
  user = aws_iam_user.dev_user.name
}
