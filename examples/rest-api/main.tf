provider "aws" {
  region = "eu-west-1"
}

locals {
  name = "terraform-aws-cors-rest"
}

resource "aws_api_gateway_rest_api" "my_api" {
  name        = local.name
  description = "API for testing CORS"
}

resource "aws_api_gateway_deployment" "my_api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  stage_name  = "test"

  triggers = {
    redeployment = timestamp()
  }

  depends_on = [
    aws_api_gateway_integration.resource_integration,

    module.cors
  ]
}

# ########################################################################
# Lambda
# ########################################################################

# Lambda function role
resource "aws_iam_role" "lambda_role" {
  name = local.name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy" "lambda_logs" {
  name = local.name
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Effect   = "Allow",
        Resource = "arn:aws:logs:*:*:*"
      },
    ]
  })
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/main.py"
  output_path = "${path.module}/lambda_function_payload.zip"
}

resource "aws_lambda_function" "my_lambda" {
  function_name    = local.name
  handler          = "main.lambda_handler"
  role             = aws_iam_role.lambda_role.arn
  runtime          = "python3.10"
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = filebase64sha256(data.archive_file.lambda_zip.output_path)

  layers = [
    "arn:aws:lambda:eu-west-1:306986787463:layer:common-python-libraries:14"
  ]

  environment {
    variables = {
      "cors" = jsonencode({
        "origins" = module.cors.origins,
        "headers" = module.cors.headers,
        "methods" = module.cors.methods
      })
    }
  }
}

resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.my_lambda.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.my_api.execution_arn}/*/*"
}

# ########################################################################
# Endpoints
# ########################################################################

# API Gateway method
resource "aws_api_gateway_method" "my_api_method" {
  rest_api_id   = aws_api_gateway_rest_api.my_api.id
  resource_id   = aws_api_gateway_rest_api.my_api.root_resource_id
  http_method   = "ANY"
  authorization = "NONE"
}

# API Gateway integration
resource "aws_api_gateway_integration" "resource_integration" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_rest_api.my_api.root_resource_id
  http_method = aws_api_gateway_method.my_api_method.http_method

  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.my_lambda.invoke_arn
  integration_http_method = "POST"
}

# ########################################################################
# CORS Setup
# ########################################################################

module "cors" {
  source = "../.."

  api_gateway_type = "REST"
  api              = aws_api_gateway_rest_api.my_api.id
  rest_resources = [
    aws_api_gateway_rest_api.my_api.root_resource_id
  ]
  allowed_origins = ["https://test-cors.org"]
  allowed_headers = ["X-PING"]
  methods         = ["GET", "POST", "PUT", "DELETE", "PATCH", "HEAD"]
}
