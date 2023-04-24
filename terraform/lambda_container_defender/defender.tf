# Protected Lambda function
variable "function_name" {
  type    = string
  default = "lambda_defender_demo"
}

variable "tw_policy" {
  type = string
  description = "Base64 string of Prisma Cloud Defender configuration"
}

variable "image_uri" {
  type = string
  description = "Container image URI for container runtime"
}

variable "original_handler" {
  type = string
  description = "Original Lambda handler used by Prisma Cloud to chain entrypoints."
}

# Account ID
data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}


resource "aws_iam_role" "lambda_execution_role" {
  name_prefix        = "lambda_"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy" "lambda" {
  name_prefix = "lambda_"
  role        = aws_iam_role.lambda_execution_role.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["logs:CreateLogGroup"]
        Resource = "arn:aws:logs:ca-central-1:${data.aws_caller_identity.current.account_id}:*"
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = ["arn:aws:logs:ca-central-1:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${var.function_name}:*"]
      }
    ]
  })
}

resource "aws_lambda_function" "lambda" {
  function_name = var.function_name
  role          = aws_iam_role.lambda_execution_role.arn
  image_uri     = var.image_uri
  package_type = "Image"
  environment {
    variables = {
      ORIGINAL_HANDLER = var.original_handler
      TW_POLICY        = var.tw_policy
    }
  }
}


terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.60.0"
    }
    random = {
      source = "hashicorp/random"
    }
  }
}

provider "aws" {
  region = "ca-central-1"
}


