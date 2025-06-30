# IAM Role for the test instance
data "aws_iam_policy_document" "assume_policy" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "ssm_session_manager" {
  name               = "experiment-instance-ssm-role"
  assume_role_policy = data.aws_iam_policy_document.assume_policy.json
}

resource "aws_iam_instance_profile" "ssm_instance_profile" {
  name = "experiment-instance-ssm-profile"
  role = aws_iam_role.ssm_session_manager.id
}

resource "aws_iam_role_policy_attachment" "ssm_managed_instance_core" {
  role       = aws_iam_role.ssm_session_manager.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Allow reading all RDS secrets
data "aws_iam_policy_document" "secrets_manager_policy" {
  statement {
    effect    = "Allow"
    actions   = ["secretsmanager:GetSecretValue", "secretsmanager:DescribeSecret"]
    resources = ["arn:aws:secretsmanager:*:*:secret:rds*"]
  }
}

resource "aws_iam_role_policy" "secrets_manager_policy" {
  name   = "secrets-manager-policy"
  role   = aws_iam_role.ssm_session_manager.id
  policy = data.aws_iam_policy_document.secrets_manager_policy.json
}