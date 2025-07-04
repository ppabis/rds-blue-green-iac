#!/bin/bash

export AWS_DEFAULT_REGION=eu-west-2

tofu apply -target module.vpc.aws_secretsmanager_secret_version.root_password
tofu apply
aws secretsmanager get-secret-value \
 --secret-id $(tofu output -raw secret_arn) \
 --query SecretString \
 --output text \
 | jq -r ".password"
aws ssm start-session \
  --target $(tofu output -raw instance_id)