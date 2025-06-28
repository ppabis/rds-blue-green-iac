# Data source for latest Amazon Linux 2023 ARM64 AMI from SSM Parameter Store
data "aws_ssm_parameter" "amazon_linux_2023_ami" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-6.1-arm64"
}

# EC2 Instance
resource "aws_instance" "experiment_instance" {
  ami                         = data.aws_ssm_parameter.amazon_linux_2023_ami.value
  instance_type               = "t4g.nano"
  iam_instance_profile        = aws_iam_instance_profile.ssm_instance_profile.name
  vpc_security_group_ids      = [aws_security_group.experiment_instance.id]
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true

  user_data = <<-EOF
    #!/bin/bash
    dnf update -y
    dnf install -y mariadb1011-client-utils postgresql17 docker
    systemctl enable --now docker
    EOF

  tags = { Name = "experiment-instance" }
  lifecycle { ignore_changes = [ ami ] }
}
