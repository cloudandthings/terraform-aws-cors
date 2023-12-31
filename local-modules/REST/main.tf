resource "aws_api_gateway_method" "cors_method" {
  for_each      = toset(var.resources)
  rest_api_id   = var.api
  resource_id   = each.value
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "cors_integration" {
  for_each    = toset(var.resources)
  rest_api_id = var.api
  resource_id = each.value
  http_method = aws_api_gateway_method.cors_method[each.key].http_method
  type        = "MOCK"

  request_templates = {
    "application/json" = <<EOF
{ "statusCode": 200 }
EOF
  }
}

resource "aws_api_gateway_method_response" "cors_method_response" {
  for_each    = toset(var.resources)
  rest_api_id = var.api
  resource_id = each.value
  http_method = aws_api_gateway_method.cors_method[each.key].http_method

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
  for_each    = toset(var.resources)
  rest_api_id = var.api
  resource_id = aws_api_gateway_method.cors_method[each.key].resource_id
  http_method = aws_api_gateway_method.cors_method[each.key].http_method
  status_code = aws_api_gateway_method_response.cors_method_response[each.key].status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'${var.headers}'"
    "method.response.header.Access-Control-Allow-Methods" = "'${var.methods}'"
    "method.response.header.Access-Control-Allow-Origin"  = "'${var.origin[0]}'"
  }
}
