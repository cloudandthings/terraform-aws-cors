# Terraform AWS CORS
A single module to setup CORS for both REST and HTTP APIs.

## Headers
The following commonly used headers are set by default: `Content-Type`, `X-Amz-Date`, `Authorization`, `X-Api-Key`, `X-Amz-Security-Token`. These can be disbaled using the `disable_default_headers` variable.

Additional headers can be set using the `allowed_headers` variable.

## Usage with REST API (v1)
### Basic usage
`REST` APIs only support a single origin, if more than one is supplied the module will throw a validation error.

```hcl
module "basic_cors_rest" {
  source  = "cloudandthings/cors/aws"
  version = "1.0.0"

  api_gateway_type = 'REST'
  api              = aws_api_gateway_rest_api.your_api.id

  resources = [
    aws_api_gateway_resource.a.id,
    aws_api_gateway_resource.b.id
  ]

  methods = [
    "GET",
    "POST"
  ]

  allowed_origins = ['*']
}
```

### All features
```hcl
module "basic_cors_rest" {
  source  = "cloudandthings/cors/aws"
  version = "1.0.0"

  api_gateway_type = "REST"
  api              = aws_api_gateway_rest_api.your_api.id

  resources = [
    aws_api_gateway_resource.a.id,
    aws_api_gateway_resource.b.id
  ]

  methods = [
    "GET",
    "POST",
    "PUT",
    "DELETE",
    "HEAD",
    "PATCH",
    "OPTIONS"
  ]

  allowed_origins = ["http://your_domain"]

  disable_default_headers = true

  allowed_headers = [
    "Authentication"
  ]
}
```

## Usage with HTTP API (v2)


## Caveats
- **PROXY_INTEGRATION** does not allow you to modify the response. This means you need to set the CORS headers in your code (see examples folder).
- The module will create an `OPTIONS` method on every provided API resource. The browser will not always send a preflight request, this can be forced by adding some custom header ("X-PING: pong").

<!-- BEGIN_TF_DOCS -->
## Terraform Documentation
### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_headers"></a> [allowed\_headers](#input\_allowed\_headers) | A list of additionally allowed headers. If you are using Access-Control-Allow-Headers as a wildcard, you must specify ['*'] explicitly. | `list(string)` | `[]` | no |
| <a name="input_allowed_origins"></a> [allowed\_origins](#input\_allowed\_origins) | A list of allowed origins. REST API only support a single origin. | `list(string)` | n/a | yes |
| <a name="input_api"></a> [api](#input\_api) | ID of the API Gateway. | `string` | n/a | yes |
| <a name="input_api_gateway_type"></a> [api\_gateway\_type](#input\_api\_gateway\_type) | The type of the API Gateway to create. Valid values are REST (v1) or HTTP (v2). Defaults to REST. | `string` | n/a | yes |
| <a name="input_disable_default_headers"></a> [disable\_default\_headers](#input\_disable\_default\_headers) | Whether to disable the default headers. Defaults to false. | `bool` | `false` | no |
| <a name="input_methods"></a> [methods](#input\_methods) | List of permitted HTTP methods. OPTIONS is added by default. | `list(string)` | n/a | yes |
| <a name="input_rest_resources"></a> [rest\_resources](#input\_rest\_resources) | List of the IDs of an aws\_api\_gateway\_resource resource. This must be set if api\_gateway\_type is REST. | `list(string)` | `[]` | no |

----
### Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_http"></a> [http](#module\_http) | ./local-modules/HTTP | n/a |
| <a name="module_rest"></a> [rest](#module\_rest) | ./local-modules/REST | n/a |

----
### Outputs

| Name | Description |
|------|-------------|
| <a name="output_headers"></a> [headers](#output\_headers) | A list of headers that are allowed in a preflight request. |
| <a name="output_methods"></a> [methods](#output\_methods) | A list of methods that are allowed in a preflight request. |
| <a name="output_origins"></a> [origins](#output\_origins) | A list of origins that are allowed in a preflight request. |

----
### Providers

No providers.

----
### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.15.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.9 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >= 3.1 |

----
### Resources

No resources.

----
<!-- END_TF_DOCS -->
