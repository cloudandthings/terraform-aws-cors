# Local Module for the REST API CORS setup
<!-- BEGIN_TF_DOCS -->
## Terraform Documentation
### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_api"></a> [api](#input\_api) | ID of the API Gateway. | `string` | n/a | yes |
| <a name="input_headers"></a> [headers](#input\_headers) | Concatenated list of allowed headers. | `string` | n/a | yes |
| <a name="input_methods"></a> [methods](#input\_methods) | Concatenated list of allowed methods. | `string` | n/a | yes |
| <a name="input_origin"></a> [origin](#input\_origin) | A list of allowed origins. Defaults to '*'. | `list(string)` | n/a | yes |
| <a name="input_resources"></a> [resources](#input\_resources) | List of the IDs of an aws\_api\_gateway\_resource resource. This must be set if api\_gateway\_type is REST. | `list(string)` | n/a | yes |

----
### Modules

No modules.

----
### Outputs

No outputs.

----
### Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.9 |

----
### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.15.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.9 |

----
### Resources

| Name | Type |
|------|------|
| [aws_api_gateway_integration.cors_integration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_integration) | resource |
| [aws_api_gateway_integration_response.cors_integration_response](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_integration_response) | resource |
| [aws_api_gateway_method.cors_method](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_method) | resource |
| [aws_api_gateway_method_response.cors_method_response](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_method_response) | resource |

----
<!-- END_TF_DOCS -->
