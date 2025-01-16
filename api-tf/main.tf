resource "aws_apigatewayv2_api" "this" {
  name          = local.name
  protocol_type = var.protocol_type
  tags          = local.tags
}

resource "aws_apigatewayv2_route" "this" {
  for_each  = { for key, value in var.route_keys : key => value }
  api_id    = aws_apigatewayv2_api.this.id
  route_key = each.value
  target    = "integrations/${aws_apigatewayv2_integration.this.id}"
}


## TODO make this optional 
# resource "aws_apigatewayv2_authorizer" "this" {
#   count                             = var.authorizer_name != null ? 1 : 0
#   name                              = var.authorizer_name
#   api_id                            = aws_apigatewayv2_api.this.id
#   authorizer_type                   = var.authorizer_type
#   identity_sources                  = var.identity_sources
#   authorizer_credentials_arn        = var.authorizer_credentials_arn
#   authorizer_payload_format_version = var.authorizer_payload_format_version
#   authorizer_result_ttl_in_seconds  = var.authorizer_result_ttl_in_seconds
#   authorizer_uri                    = var.authorizer_uri
#   enable_simple_responses           = var.enable_simple_responses
#   jwt_configuration {
#     audience = var.jwt_audience
#     issuer   = var.jwt_issuer
#   }
# }

resource "aws_apigatewayv2_deployment" "this" {
  api_id      = aws_apigatewayv2_api.this.id
  description = var.deployment_description
  depends_on  = [aws_apigatewayv2_route.this]
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_apigatewayv2_stage" "this" {
  api_id                = aws_apigatewayv2_api.this.id
  name                  = var.stage_name
  deployment_id         = aws_apigatewayv2_deployment.this.id
  auto_deploy           = var.auto_deploy
  description           = var.stage_description
  client_certificate_id = var.client_certificate_id
  stage_variables       = var.stage_variables
  tags                  = var.tags

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.this.arn
    format = jsonencode({
      accountId                        = "$context.accountId"
      apiId                            = "$context.apiId"
      auth-claims                      = "$context.authorizer.claims.property"
      auth-error                       = "$context.authorizer.error"
      auth-principleId                 = "$context.authorizer.principalId"
      auth-property                    = "$context.authorizer.property"
      awsEndpointRequestId             = "$context.awsEndpointRequestId"
      awsEndpointRequestId2            = "$context.awsEndpointRequestId2"
      custom-domian-basePathMatched    = "$context.customDomain.basePathMatched"
      dataProcessed                    = "$context.dataProcessed"
      domainName                       = "$context.domainName"
      domainPrefix                     = "$context.domainPrefix"
      error-message                    = "$context.error.message"
      error-messageString              = "$context.error.messageString"
      error-responseType               = "$context.error.responseType"
      extendedRequestId                = "$context.extendedRequestId"
      httpMethod                       = "$context.httpMethod"
      id-accountId                     = "$context.identity.accountId"
      id-caller                        = "$context.identity.caller"
      id-cognitoAuthenticationProvider = "$context.identity.cognitoAuthenticationProvider"
      id-cognitoAuthenticationType     = "$context.identity.cognitoAuthenticationType"
      id-cognitoIdentityId             = "$context.identity.cognitoIdentityId"
      id-cognitoIdentityPoolId         = "$context.identity.cognitoIdentityPoolId"
      id-principalOrgId                = "$context.identity.principalOrgId"
      id-clientCert-clientCertPem      = "$context.identity.clientCert.clientCertPem"
      id-clientCert-subjectDN          = "$context.identity.clientCert.subjectDN"
      id-clientCert-issuerDN           = "$context.identity.clientCert.issuerDN"
      id-clientCert-serialNumber       = "$context.identity.clientCert.serialNumber"
      id-clientCert-validity-notBefore = "$context.identity.clientCert.validity.notBefore"
      id-clientCert-validity-notAfter  = "$context.identity.clientCert.validity.notAfter"
      id-sourceIp                      = "$context.identity.sourceIp"
      id-user                          = "$context.identity.user"
      id-userAgent                     = "$context.identity.userAgent"
      id-userArn                       = "$context.identity.userArn"
      integration-error                = "$context.integration.error"
      integration-integrationStatus    = "$context.integration.integrationStatus"
      integration-latency              = "$context.integration.latency"
      integration-requestId            = "$context.integration.requestId"
      integration-status               = "$context.integration.status"
      integrationErrorMessage          = "$context.integrationErrorMessage"
      integrationLatency               = "$context.integrationLatency"
      integrationStatus                = "$context.integrationStatus"
      path                             = "$context.path"
      protocol                         = "$context.protocol"
      requestId                        = "$context.requestId"
      requestTime                      = "$context.requestTime"
      routeKey                         = "$context.routeKey"
      stage                            = "$context.stage"
      status                           = "$context.status"
    })
  }

  default_route_settings {
    data_trace_enabled       = var.default_data_trace_enabled
    detailed_metrics_enabled = var.default_detailed_metrics_enabled
    logging_level            = var.default_logging_level
    throttling_burst_limit   = var.default_throttling_burst_limit
    throttling_rate_limit    = var.default_throttling_rate_limit
  }

  dynamic "route_settings" {
    for_each = var.route_settings
    content {
      route_key                = route_settings.value.route_key
      data_trace_enabled       = route_settings.value.data_trace_enabled
      detailed_metrics_enabled = route_settings.value.detailed_metrics_enabled
      logging_level            = route_settings.value.logging_level
      throttling_burst_limit   = route_settings.value.throttling_burst_limit
      throttling_rate_limit    = route_settings.value.throttling_rate_limit
    }
  }
}

resource "aws_apigatewayv2_vpc_link" "this" {

  count              = var.create_vpc_link == true ? 1 : 0
  name               = local.vpc_link_name
  subnet_ids         = var.subnet_ids
  security_group_ids = var.security_group_ids
  tags               = var.tags
}

resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/apigateway/${aws_apigatewayv2_api.this.name}/stage/access"
  skip_destroy      = var.log_group_skip_destroy
  log_group_class   = var.log_group_class
  retention_in_days = var.log_group_retention_in_days
  tags              = var.tags
}

resource "aws_apigatewayv2_integration" "this" {
  api_id             = aws_apigatewayv2_api.this.id
  integration_type   = var.integration_type
  integration_uri    = var.integration_uri
  integration_method = var.integration_method
  connection_type    = var.integration_type == "HTTP" || var.integration_type == "HTTP_PROXY" ? "VPC_LINK" : null
  connection_id      = var.create_vpc_link == true ? aws_apigatewayv2_vpc_link.this[0].id : null
  request_parameters = var.request_parameters
}

resource "aws_apigatewayv2_domain_name" "this" {
  count       = length(var.domain_name) > 0 ? 1 : 0
  domain_name = var.domain_name
  domain_name_configuration {
    certificate_arn = var.certificate_arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }
}