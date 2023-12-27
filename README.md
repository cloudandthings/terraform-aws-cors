# Terraform AWS CORS
The last module you'll need to setup CORS for AWS API Gateway.

## Headers
The following commonly used headers are set by default: 'Content-Type', 'X-Amz-Date', 'Authorization', 'X-Api-Key', 'X-Amz-Security-Token'. These can be disbaled using the `disable_default_headers` variable.

Additional headers can be set using the `allowed_headers` variable.

## TF Docs
<!-- BEGIN_TF_DOCS -->
{{ .Content }}
<!-- END_TF_DOCS -->