variable "api" {
  description = "ID of the API Gateway."
  type        = string
}

variable "headers" {
  description = "Concatenated list of allowed headers."
  type        = string
}

variable "methods" {
  description = "Concatenated list of allowed methods."
  type        = string
}

variable "origin" {
  description = "A list of allowed origins. Defaults to '*'."
  type        = list(string)

  validation {
    condition     = length(var.origin) == 1
    error_message = "Exactly one origin needs to be supplied for a REST API."
  }
}

variable "resources" {
  description = "List of the IDs of an aws_api_gateway_resource resource. This must be set if api_gateway_type is REST."
  type        = list(string)

  validation {
    condition     = length(var.resources) > 0
    error_message = "At least one REST resource must be specified."
  }

  validation {
    condition     = length(var.resources) == length(distinct(var.resources))
    error_message = "The resources list must not contain duplicates."
  }

}
