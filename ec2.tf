# Provision an EC2 instance
resource "aws_instance" "secure_ubuntu" {
  ami                  = var.ami_id                                         # Use AMI ID from variables
  instance_type        = var.instance_type                                  # Use instance type from variables
  iam_instance_profile = aws_iam_instance_profile.ssm_instance_profile.name # Associate the IAM role
  security_groups      = [aws_security_group.secure_sg.name]                # Attach security group

  tags = {
    Name    = "Ubuntu-Instance"
    Project = "Week1"
  }
}
