


Important things to Note:


Handler: components.sample_component_1.lambdas.sample_lambda_1.src.handler.lambda_handler

Lambda function directory path:
components/sample_component_1/lambdas/sample_lambda_1/src/handler.py

These all folders will become the part of .zip file when the lambda function is deployed.

This way we can run all tests and imports directly and indirectly without making any changes.

__init__.py file was not required.


Local Development and Testing Guide

Pre-requisites:
- Set up python environment
- Install requirements
- Set up terraform
- Set up terragrunt

1. Make changes to your code or infra
2. For code changes, test them locally
3. Package your lambda in .zip file
4. Upload to S3 bucket, this will create a new version in S3 and generate a new version id. In CICD, we can have checksums that sees if we need to update a file or not. If yes, then proceed to next steps else not required.
5. Run terraform apply to deploy the changes

# TODO:

Try out the lambda module from terraform-aws-modules repository.

Write the commands for above process.

Create a CICD flow to deploy to sandbox account.
