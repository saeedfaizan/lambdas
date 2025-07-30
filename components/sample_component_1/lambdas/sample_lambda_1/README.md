## Local Development and Testing Guide

### Prerequisites(first time setup)
1. Set up python environment
   1. Using `conda` (@TODO: Check best practice for python env)
      1. Create a conda environment: `conda create -n lambdas python=$(cat .python-version)`
      2. Activate the conda environment: `conda activate lambdas`
   2. Using `venv`(@TODO: Not tested)
       - Create a virtual environment: `python3 -m venv .venv`
       - Activate the virtual environment: `source .venv/bin/activate`
2. Install requirements. @TODO: For local development and testing, it will be lot easier to maintain a single requirements.txt file at the root of the lambda function directory.
   @TODO: Alternatively, we could think about using `.toml` for managing dependencies.
   ```shell
   pip install -r requirements-local.txt
   ```
3. Install [tfenv](https://github.com/tfutils/tfenv) (for enabling use of older Terraform version - to use same version as used by GitHub actions)
   - Use Homebrew to install tfenv: ```brew install tfenv```
   - switch to configured Terraform version
   - Set default Terraform version: `tfenv use $(cat .terraform-version)`
4. Install [tgswitch](https://github.com/warrensbox/tgswitch) (for enabling use of older Terragrunt version - to use same version as used by GitHub actions)
   - Use Homebrew to install tgswitch: `brew install warrensbox/tap/tgswitch`
   - Switch to configured Terragrunt version: `tgswitch $(cat ./.terragrunt-version)`
5. Bootstrap environment
   ```shell
   cd environments/prod/bootstrap
   terragrunt apply
   ```
   Note: Select `y` when asked to create the S3 bucket.
6. Create S3 bucket for lambda deployment
   ```shell
   export BUCKET_NAME="013186329397-my-lambda-bucket"
   aws s3api create-bucket --bucket $BUCKET_NAME --region eu-central-1 --create-bucket-configuration LocationConstraint=eu-central-1
   aws s3api put-bucket-versioning --bucket $BUCKET_NAME --versioning-configuration Status=Enabled
   ```

### Deployment Guide

1. Make changes to your code or infra. If you changed code, then follow step 2 else directly jump to step 5.
2. For code changes, test them locally
    ```shell
    python -m unittest discover -s components/sample_component_1/lambdas/sample_lambda_1/tests
    ```
3. Package your lambda in .zip file
    ```shell
    zip -r builds/sample_lambda_1.zip components/sample_component_1/lambdas/sample_lambda_1/src -i '*.py'
    ```
4. Upload to S3 bucket, this will create a new version in S3 and return the version id of the object
    ```shell
   aws s3 cp builds/sample_lambda_1.zip s3://$BUCKET_NAME/sample_lambda_1.zip
    ```
5. Go to the required environment(e.g. sandbox) and then run terraform apply to deploy the changes
   ```shell
   cd components/sample_component_1/lambdas/sample_lambda_1/infra/sandbox
   terragrunt apply
   ```

In CICD, we can have checksums that sees if we need to update a file or not. If yes, then proceed to next steps else not required.

### TODO:
- Create a CICD flow to deploy to sandbox account.
- Try out the lambda module from terraform-aws-modules repository.


### Important things to Note:

Handler: components.sample_component_1.lambdas.sample_lambda_1.src.handler.lambda_handler

Lambda function directory path:
components/sample_component_1/lambdas/sample_lambda_1/src/handler.py

These all folders will become the part of .zip file when the lambda function is deployed.

This way we can run all tests and imports directly and indirectly without making any changes.

__init__.py file was not required.
