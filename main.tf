resource "aws_security_group" "alb_sg" {
  name        = "alb-security-group"
  description = "Security group for ALB"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb-security-group"
  }
}

resource "aws_lb" "main" {
  name               = "test-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = ["subnet-0039c8f67e9731cd0", "subnet-0260b686027560d35"]

  enable_deletion_protection = false
  
}

# resource "aws_lb_listener" "front_end" {
#   load_balancer_arn = aws_lb.main.arn
#   port              = "80"
#   protocol          = "HTTP"

#   default_action {
#     type = "redirect"

#     redirect {
#       port        = "443"
#       protocol    = "HTTPS"
#       status_code = "HTTP_301"
#     }
#   }
# }

module "alb_http_listener" {
  source            = ".//.."
  alb_name          = aws_lb.main.name
  load_balancer_arn = aws_lb.main.arn
  protocal          = "HTTP"
  port              = 80
  default_rule = [{
    type = "redirect"
    redirect = [{
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }]
    authenticate_cognito = []
    authenticate_oidc    = []
    fixed_response      = []
    forward             = []
  }]
  listener_rules = []
}


# module "api_gateway" {
#   source = "./api-tf"

#   protocol_type      = "HTTP"
#   integration_type   = "HTTP_PROXY"
#   integration_uri    = module.alb_http_listener.alb_listener_arn
#   integration_method = "POST"
#   route_keys = {
#     "POST /"       = "POST /",
#     "GET /"        = "GET /",
#     "GET /status"  = "GET /status",
#     "POST /submit" = "POST /submit",
#     "PUT /update"  = "PUT /update"
#   }
#   /*authorizer_name      = "rtlh-authorizer"
#   authorizer_type      = "REQUEST"
#   identity_sources     = ["$request.header.Authorization"]*/
#   deployment_description = "Initial deployment"
#   stage_name             = "dev"
#   auto_deploy            = true
#   stage_description      = "Development stage"
#   #client_certificate_id = "client-cert-id"
#   stage_variables = {
#     "env" = "dev"
#   }

#   default_data_trace_enabled       = false
#   default_detailed_metrics_enabled = false
#   default_logging_level            = "OFF"
#   default_throttling_burst_limit   = 5000
#   default_throttling_rate_limit    = 10000

#   route_settings = [
#     {
#       route_key                = "POST /"
#       data_trace_enabled       = false
#       detailed_metrics_enabled = false
#       logging_level            = "INFO"
#       throttling_burst_limit   = 2000
#       throttling_rate_limit    = 5000
#     },
#     {
#       route_key                = "GET /"
#       data_trace_enabled       = false
#       detailed_metrics_enabled = false
#       logging_level            = "INFO"
#       throttling_burst_limit   = 2000
#       throttling_rate_limit    = 5000
#     },
#     {
#       route_key                = "GET /status"
#       data_trace_enabled       = false
#       detailed_metrics_enabled = false
#       logging_level            = "INFO"
#       throttling_burst_limit   = 2000
#       throttling_rate_limit    = 5000
#     },
#     {
#       route_key                = "POST /submit"
#       data_trace_enabled       = false
#       detailed_metrics_enabled = false
#       logging_level            = "INFO"
#       throttling_burst_limit   = 2000
#       throttling_rate_limit    = 5000
#     },
#     {
#       route_key                = "PUT /update"
#       data_trace_enabled       = false
#       detailed_metrics_enabled = false
#       logging_level            = "INFO"
#       throttling_burst_limit   = 2000
#       throttling_rate_limit    = 5000
#     }
#   ]
#   subnet_ids         = ["subnet-0039c8f67e9731cd0", "subnet-0260b686027560d35"]
#   security_group_ids = [aws_security_group.alb_sg.id]
# }


module "api_gateway_hhttp" {
  source = "./api-tf"

  protocol_type      = "HTTP"
  integration_type   = "HTTP_PROXY"
  integration_uri    = module.alb_http_listener.alb_listener_arn
  integration_method = "ANY"
  route_keys = {
    "POST /"       = "POST /",
    "GET /"        = "GET /",
    "GET /status"  = "GET /status",
    "POST /submit" = "POST /submit",
    "PUT /update"  = "PUT /update"
  }
  /*authorizer_name      = "rtlh-authorizer"
  authorizer_type      = "REQUEST"
  identity_sources     = ["$request.header.Authorization"]*/
  deployment_description = "Initial deployment"
  stage_name             = "dev"
  auto_deploy            = false
  stage_description      = "Development stage"
  #client_certificate_id = "client-cert-id"
  stage_variables = {
    "env" = "dev"
  }

  default_data_trace_enabled       = false
  default_detailed_metrics_enabled = false
  default_logging_level            = "OFF"
  default_throttling_burst_limit   = 5000
  default_throttling_rate_limit    = 10000

  request_parameters = {
    "overwrite:path"  = "$request.path"
    "overwrite:header.host" = aws_lb.main.dns_name
  }

  route_settings = [
    {
      route_key                = "POST /"
      data_trace_enabled       = false
      detailed_metrics_enabled = false
      logging_level            = "INFO"
      throttling_burst_limit   = 2000
      throttling_rate_limit    = 5000
    },
    {
      route_key                = "GET /"
      data_trace_enabled       = false
      detailed_metrics_enabled = false
      logging_level            = "INFO"
      throttling_burst_limit   = 2000
      throttling_rate_limit    = 5000
    },
    {
      route_key                = "GET /status"
      data_trace_enabled       = false
      detailed_metrics_enabled = false
      logging_level            = "INFO"
      throttling_burst_limit   = 2000
      throttling_rate_limit    = 5000
    },
    {
      route_key                = "POST /submit"
      data_trace_enabled       = false
      detailed_metrics_enabled = false
      logging_level            = "INFO"
      throttling_burst_limit   = 2000
      throttling_rate_limit    = 5000
    },
    {
      route_key                = "PUT /update"
      data_trace_enabled       = false
      detailed_metrics_enabled = false
      logging_level            = "INFO"
      throttling_burst_limit   = 2000
      throttling_rate_limit    = 5000
    }
  ]
  subnet_ids         = ["subnet-0039c8f67e9731cd0", "subnet-0260b686027560d35"]
  security_group_ids = [aws_security_group.alb_sg.id]
}

module "api_gateway_websocket" {
  source = "./api-tf"

  context = "02"
  protocol_type      = "WEBSOCKET"
  integration_type   = "AWS_PROXY"
  integration_uri    = aws_lambda_function.connect_handler.invoke_arn
  integration_method = "POST"
  create_vpc_link    = false
  
  # Define only the connect route for testing
  route_keys = {
    "$connect" = "$connect"
  }

  deployment_description = "WebSocket Connect Test"
  stage_name            = "dev"
  auto_deploy           = false
  stage_description     = "Development WebSocket Test Stage"

  stage_variables = {
    "env" = "dev"
  }

  # Basic settings for testing
  default_data_trace_enabled       = true
  default_detailed_metrics_enabled = true
  default_logging_level           = "INFO"
  default_throttling_burst_limit  = 500
  default_throttling_rate_limit   = 1000

  route_settings = [
    {
      route_key                = "$connect"
      data_trace_enabled       = true
      detailed_metrics_enabled = true
      logging_level           = "INFO"
      throttling_burst_limit  = 200
      throttling_rate_limit   = 500
    }
  ]

  subnet_ids         = ["subnet-0039c8f67e9731cd0", "subnet-0260b686027560d35"]
  security_group_ids = [aws_security_group.alb_sg.id]
}

# You'll need Lambda functions to handle the WebSocket routes
resource "aws_lambda_function" "connect_handler" {
  filename         = "connect_handler.zip"
  function_name    = "websocket_connect_handler_test"
  role            = aws_iam_role.lambda_role.arn
  handler         = "connect_handler.lambda_handler"
  runtime         = "python3.12"

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.connections.name
    }
  }
}

# Additional Lambda functions for disconnect and message handling
# ... similar Lambda function definitions for other handlers

# DynamoDB table to store connection IDs
resource "aws_dynamodb_table" "connections" {
  name           = "websocket-connections"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "connectionId"
  
  attribute {
    name = "connectionId"
    type = "S"
  }
}

resource "aws_lambda_permission" "websocket_connect" {
  statement_id  = "AllowWebSocketAPIConnect"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.connect_handler.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${module.api_gateway_websocket.api_execution_arn}/*"
}

# IAM role for Lambda functions
resource "aws_iam_role" "lambda_role" {
  name = "websocket_lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}


# This allows Lambda functions to create and write logs
resource "aws_iam_role_policy" "lambda_cloudwatch" {
  name = "websocket_lambda_cloudwatch"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

# Policy for DynamoDB access
# This allows Lambda functions to manage WebSocket connection IDs in DynamoDB
resource "aws_iam_role_policy" "lambda_dynamodb" {
  name = "websocket_lambda_dynamodb"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:DeleteItem",
          "dynamodb:Scan",
          "dynamodb:Query",
          "dynamodb:UpdateItem"
        ]
        Resource = aws_dynamodb_table.connections.arn
      }
    ]
  })
}

# Policy for API Gateway Management API
# This allows Lambda functions to send messages back through WebSocket connections
resource "aws_iam_role_policy" "lambda_apigateway" {
  name = "websocket_lambda_apigateway"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "execute-api:ManageConnections",
          "execute-api:Invoke"
        ]
        Resource = [
          "${module.api_gateway_websocket.api_execution_arn}/*"
        ]
      }
    ]
  })
}

