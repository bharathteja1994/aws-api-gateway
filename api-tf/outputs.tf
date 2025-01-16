output "api_id" {
  value = aws_apigatewayv2_api.this.id
}

output "vpc_link_id" {
  value = var.create_vpc_link == true ? aws_apigatewayv2_vpc_link.this[0].id : null
}

output "stage_id" {
  value = aws_apigatewayv2_stage.this.id
}

output "api_execution_arn" {
  description = "The execution ARN of the WebSocket API"
  value       = aws_apigatewayv2_api.this.execution_arn
}