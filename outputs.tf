output "headers" {
  description = "A list of headers that are allowed in a preflight request."
  value       = local.all_headers_list
}

output "methods" {
  description = "A list of methods that are allowed in a preflight request."
  value       = local.methods_list
}

output "origins" {
  description = "A list of origins that are allowed in a preflight request."
  value       = var.allowed_origins
}
