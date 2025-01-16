variable "protocol_type" {
  description = "API protocol. Valid values: HTTP, WEBSOCKET"
  type        = string
  default     = "HTTP"
  
}

variable "integration_type" {
  description = "The type of the integration. Valid values: AWS (supported only for WebSocket APIs), AWS_PROXY, HTTP (supported only for WebSocket APIs), HTTP_PROXY, MOCK (supported only for WebSocket APIs). For an HTTP API private integration, use HTTP_PROXY."
  type        = string
  default     = "HTTP_PROXY"
  
}

variable "integration_uri" {
  description = "The URI of the integration. URI of the Lambda function for a Lambda proxy integration, when integration_type is AWS_PROXY. For an HTTP integration, specify a fully-qualified URL. For an HTTP API private integration, specify the ARN of an Application Load Balancer listener, Network Load Balancer listener, or AWS Cloud Map service."
  type        = string
  default     = ""
  
}
variable "integration_method" {
  description = "Integration's HTTP method. Must be specified if integration_type is not MOCK."
  type        = string
  default     = "ANY"
  
}
variable "route_keys" {
  description = "The route keys for the API. For HTTP APIs, the route key can be either $default, or a combination of an HTTP method and resource path, for example, GET /pets."
  type        = map(string)
}

# variable "authorizer_name" {
#   description = "The name of the authorizer. Must be between 1 and 128 characters in length."
#   type        = string
#   nullable    = true
#   default     = null
#   validation {
#     condition     = length(var.deployment_description) <= 128
#     error_message = "authorizer_name must be less than or equal to 128 characters in length."
#   }
# }

# variable "authorizer_type" {
#   description = "The type of the authorizer.Authorizer type. Valid values: JWT, REQUEST. Specify REQUEST for a Lambda function using incoming request parameters. For HTTP APIs, specify JWT to use JSON Web Tokens."
#   type        = string
#   nullable    = true
#   default     = null
# }

# variable "identity_sources" {
#   description = "The identity sources for which authorization is requested. For REQUEST authorizers the value is a list of one or more mapping expressions of the specified request parameters. For JWT authorizers the single entry specifies where to extract the JSON Web Token (JWT) from inbound requests."
#   type        = list(string)
#   nullable = true
#   default     = null
#   validation {
#     condition     = var.authorizer_type == "JWT" || (var.authorizer_type == "REQUEST" && length(var.identity_sources) > 0)
#     error_message = "identity_sources must be provided when authorizer_type is 'REQUEST' or 'JWT'."
#   }
# }


# variable "authorizer_credentials_arn" {
#   description = "Required credentials as an IAM role for API Gateway to invoke the authorizer. Supported only for REQUEST authorizers."
#   type        = string
#   nullable    = true
#   default     = null
#   validation {
#     condition     = var.authorizer_type == "REQUEST" && var.authorizer_credentials_arn != null
#     error_message = "authorizer credentials ARN must be provided when authorizer_type is 'REQUEST'."
#   }
# }

# variable "authorizer_payload_format_version" {
#   description = "Format of the payload sent to an HTTP API Lambda authorizer. Required for HTTP API Lambda authorizers. Valid values: 1.0, 2.0."
#   type        = string
#   nullable    = true
#   default     = null
#   validation {
#     condition     = var.authorizer_type == "REQUEST" && var.authorizer_payload_format_version != null
#     error_message = "authorizer_payload_format_version must be provided when authorizer_type is 'REQUEST'."
#   }
# }

# variable "authorizer_result_ttl_in_seconds" {
#   description = "Time to live (TTL) for cached authorizer results, in seconds. If it equals 0, authorization caching is disabled. If it is greater than 0, API Gateway caches authorizer responses. The maximum value is 3600, or 1 hour. Defaults to 300. Supported only for HTTP API Lambda authorizers."
#   type        = number
#   default     = 300
#   validation {
#     condition     = var.authorizer_type == "REQUEST" && var.authorizer_result_ttl_in_seconds >= 0 && var.authorizer_result_ttl_in_seconds <= 3600
#     error_message = "authorizer_result_ttl_in_seconds must be between 0 and 3600 when authorizer_type is 'REQUEST'."
#   }
# }

# variable "authorizer_uri" {
#   description = "Authorizer's Uniform Resource Identifier (URI). For REQUEST authorizers this must be a well-formed Lambda function URI, such as the invoke_arn attribute of the aws_lambda_function resource. Supported only for REQUEST authorizers. Must be between 1 and 2048 characters in length."
#   type        = string
#   nullable    = true
#   default     = null
#   validation {
#     condition     = var.authorizer_type == "REQUEST" && var.authorizer_uri != null
#     error_message = "authorizer_uri must be provided when authorizer_type is 'REQUEST'."
#   }
# }

# variable "enable_simple_responses" {
#   description = "Whether a Lambda authorizer returns a response in a simple format. If enabled, the Lambda authorizer can return a boolean value instead of an IAM policy. Supported only for HTTP APIs."
#   type        = bool
#   default     = false
#   validation {
#     condition     = var.authorizer_type == "REQUEST" && var.enable_simple_responses == true
#     error_message = "enable_simple_responses must be true when authorizer_type is 'REQUEST'."
#   }
# }
# variable "jwt_audience" {
#   description = "List of the intended recipients of the JWT. A valid JWT must provide an aud that matches at least one entry in this list."
#   type        = list(string)
#   default     = []
#   validation {
#     condition     = var.authorizer_type == "JWT" && length(var.jwt_audience) > 0
#     error_message = "jwt_audience must be provided when authorizer_type is 'JWT'."
#   }
# }

# variable "jwt_issuer" {
#   description = "Base domain of the identity provider that issues JSON Web Tokens, such as the endpoint attribute of the aws_cognito_user_pool resource."
#   type        = string
#   default     = null
#   validation {
#     condition     = var.authorizer_type == "JWT" && var.jwt_issuer != null
#     error_message = "jwt_issuer must be provided when authorizer_type is 'JWT'."
#   }
# }

variable "deployment_description" {
  description = "Description for the deployment resource. Must be less than or equal to 1024 characters in length."
  type        = string
  default     = ""
}

variable "stage_name" {
  description = "Name of the stage. Must be between 1 and 128 characters in length."
  type        = string
  default     = "$default"
}

variable "auto_deploy" {
  description = "Whether updates to an API automatically trigger a new deployment. Defaults to false. Applicable for HTTP APIs."
  type        = bool
  default     = false
}

variable "stage_description" {
  description = "Description for the stage. Must be less than or equal to 1024 characters in length."
  type        = string
  default     = ""
}

variable "client_certificate_id" {
  description = "Identifier of a client certificate for the stage. Use the aws_api_gateway_client_certificate resource to configure a client certificate. Supported only for WebSocket APIs."
  type        = string
  default     = ""
}

variable "stage_variables" {
  description = "Map that defines the stage variables for the stage"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Map of tags to assign to the stage. If configured with a provider"
  type        = map(string)
  default     = {}
}
variable "log_group_skip_destroy" {
  description = "Set to true if you do not wish the log group to be deleted at destroy time"
  type        = bool
  default     = false
}

variable "log_group_class" {
  description = "Specifies the log class of the log group"
  type        = string
  default     = "STANDARD"
}

variable "log_group_retention_in_days" {
  description = "Specifies the number of days you want to retain log events in the specified log group"
  type        = number
  default     = 7
}

variable "default_data_trace_enabled" {
  description = "Whether data trace logging is enabled for the default route. Affects the log entries pushed to Amazon CloudWatch Logs. Defaults to false. Supported only for WebSocket APIs."
  type        = bool
  default     = false
}

variable "default_detailed_metrics_enabled" {
  description = "Whether detailed metrics are enabled for the default route. Defaults to false."
  type        = bool
  default     = false
}

variable "default_logging_level" {
  description = "Logging level for the default route. Affects the log entries pushed to Amazon CloudWatch Logs. Valid values: ERROR, INFO, OFF. Defaults to OFF. Supported only for WebSocket APIs. Terraform will only perform drift detection of its value when present in a configuration."
  type        = string
  default     = "OFF"
}

variable "default_throttling_burst_limit" {
  description = "Throttling burst limit for the default route"
  type        = number
  default     = 0
}

variable "default_throttling_rate_limit" {
  description = "Throttling rate limit for the default route"
  type        = number
  default     = 0
}

variable "route_settings" {
  description = "Route settings for the stage"
  type = list(object({
    route_key                = string
    data_trace_enabled       = bool
    detailed_metrics_enabled = bool
    logging_level            = string
    throttling_burst_limit   = number
    throttling_rate_limit    = number
  }))
  default = []
}
variable "context" {
  description = "(Optional) The context that the resource is deployed in. e.g. devops, logs, lake"
  type        = string
  default     = "01"
}

variable "create_vpc_link" {
  type = bool
  default = true
}

variable "subnet_ids" {
  description = "The subnet IDs for the VPC Link"
  type        = list(string)
}

variable "security_group_ids" {
  description = "The security group IDs for the VPC Link"
  type        = list(string)

}

variable "request_parameters" {
  description = "(Optional) a key-value map specifying request parameters that are passed from the method request to the backend."
  type        = map(string)
  nullable    = true
  default     = null
}

variable "domain_name" {
  description = "(Optional) Domain name. Must be between 1 and 512 characters in length."
  type        = string
  default     = ""
}

variable "certificate_arn" {
  description = "(Optional) ARN of an AWS-managed certificate that will be used by the endpoint for the domain name."
  type        = string
  default     = ""
}