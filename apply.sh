#!/bin/bash

tofu apply -target module.vpc.aws_secretsmanager_secret_version.root_password
tofu apply