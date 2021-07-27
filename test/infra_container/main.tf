terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  version                     = ">= 2.15"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_get_ec2_platforms      = true
  skip_region_validation      = true
  skip_requesting_account_id  = true
  max_retries                 = 1
  access_key                  = "a"
  secret_key                  = "a"
  region                      = "eu-west-1"
}

module "lambda" {
  source                         = "../.."
  image_uri                      = "image"
  function_name                  = "check_lambda_function"
  handler                        = "unused"
  runtime                        = "provided"
}

output "lambda_function_arn" {
  value = module.lambda.lambda_arn
}
