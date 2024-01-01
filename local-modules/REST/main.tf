resource "aws_api_gateway_method" "cors_method" {
  count         = length(var.resources)
  rest_api_id   = var.api
  resource_id   = var.resources[count.index]
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "cors_integration" {
  count       = length(var.resources)
  rest_api_id = var.api
  resource_id = var.resources[count.index]
  http_method = aws_api_gateway_method.cors_method[count.index].http_method
  type        = "MOCK"

  request_templates = {
    "application/json" = <<EOF
{ "statusCode": 200 }
EOF
  }
}

resource "aws_api_gateway_method_response" "cors_method_response" {
  count       = length(var.resources)
  rest_api_id = var.api
  resource_id = var.resources[count.index]
  http_method = aws_api_gateway_method.cors_method[count.index].http_method

  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_integration_response" "cors_integration_response" {
  count       = length(var.resources)
  rest_api_id = var.api
  resource_id = aws_api_gateway_method.cors_method[count.index].resource_id
  http_method = aws_api_gateway_method.cors_method[count.index].http_method
  status_code = aws_api_gateway_method_response.cors_method_response[count.index].status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'${var.headers}'"
    "method.response.header.Access-Control-Allow-Methods" = "'${var.methods}'"
    "method.response.header.Access-Control-Allow-Origin"  = "'${var.origin[0]}'"
  }
}
