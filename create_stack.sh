#!/bin/bash
STACK_NAME=jessiek-translate-stack
TEMPLATE_FILE=template.yaml
REGION=us-east-1



aws cloudformation deploy \
  --template-file $TEMPLATE_FILE \
  --stack-name $STACK_NAME \
  --capabilities CAPABILITY_NAMED_IAM \
  --region $REGION