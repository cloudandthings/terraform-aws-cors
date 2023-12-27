module "rest" {

  for_each = var.api_gateway_type == "REST" ? toset([var.api_gateway_type]) : toset([])

  source = "./local-modules/REST"

  api       = var.api
  origin    = var.allowed_origins
  methods   = local.methods
  headers   = local.all_headers
  resources = var.rest_resources
}

module "http" {
  for_each = var.api_gateway_type == "HTTP" ? toset([var.api_gateway_type]) : toset([])

  source = "./local-modules/HTTP"
}
