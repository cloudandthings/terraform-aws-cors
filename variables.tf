variable "api" {
  description = "ID of the API Gateway."
  type        = string
}

variable "api_gateway_type" {
  description = "The type of the API Gateway to create. Valid values are REST (v1) or HTTP (v2). Defaults to REST."
  type        = string

  validation {
    condition     = contains(["REST", "HTTP"], var.api_gateway_type)
    error_message = "api_gateway_type must be either REST or HTTP."
  }
}

variable "methods" {
  description = "List of permitted HTTP methods. OPTIONS is added by default."
  type        = list(string)

  validation {
    condition     = alltrue([for method in var.methods : contains(["GET", "POST", "PUT", "DELETE", "HEAD", "PATCH", "OPTIONS"], method)])
    error_message = "Methods must be a list of valid HTTP methods."
  }

  validation {
    condition     = length(var.methods) > 0
    error_message = "At least one method needs to be supplied."
  }
}

variable "allowed_origins" {
  description = "A list of allowed origins. REST API only support a single origin."
  type        = list(string)

  validation {
    condition     = length(var.allowed_origins) >= 1
    error_message = "At least one allowed origin must be specified."
  }
}

variable "disable_default_headers" {
  description = "Whether to disable the default headers. Defaults to false."
  type        = bool

  default = false

}

variable "allowed_headers" {
  description = "A list of additionally allowed headers. If you are using Access-Control-Allow-Headers as a wildcard, you must specify ['*'] explicitly."
  type        = list(string)

  default = []
}

# ______ _____ _____ _____
# | ___ \  ___/  ___|_   _|
# | |_/ / |__ \ `--.  | |
# |    /|  __| `--. \ | |
# | |\ \| |___/\__/ / | |
# \_| \_\____/\____/  \_/
#
# These variables are only used for REST (v1) API Gateways.
variable "rest_resources" {
  description = "List of the IDs of an aws_api_gateway_resource resource. This must be set if api_gateway_type is REST."
  type        = list(string)
  default     = []

  # This validation sits in the local REST module.
}

#  _   _ _____ ___________
# | | | |_   _|_   _| ___ \
# | |_| | | |   | | | |_/ /
# |  _  | | |   | | |  __/
# | | | | | |   | | | |
# \_| |_/ \_/   \_/ \_|
#
# These variables are only used for HTTP (v2) API Gateways.
