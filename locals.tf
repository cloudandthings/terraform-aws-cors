locals {

  options_method = "OPTIONS"

  default_headers = var.disable_default_headers ? [] : [
    "Content-Type",
    "X-Amz-Date",
    "Authorization",
    "X-Api-Key",
    "X-Amz-Security-Token"
  ]
  all_headers_list = distinct(concat(var.allowed_headers, local.default_headers))
  all_headers      = join(",", local.all_headers_list)

  methods_list = distinct(concat(var.methods, [local.options_method]))
  methods      = join(",", local.methods_list)
}
