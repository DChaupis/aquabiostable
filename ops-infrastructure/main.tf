provider "aws" {
  region = "us-east-1" 
}

# Crear S3 para el Frontend
resource "aws_s3_bucket" "frontend_bucket" {
  bucket = "aquabiostable-frontend" 
  acl    = "public-read"

  website {
    index_document = "index.html"
  }
}

# CloudFront Distribution
resource "aws_cloudfront_distribution" "frontend_distribution" {
  origin {
    domain_name = aws_s3_bucket.frontend_bucket.bucket_regional_domain_name
    origin_id   = "S3-aquabiostable-frontend"
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-aquabiostable-frontend"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
  }

  price_class = "PriceClass_All"
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

# Crear API Gateway
resource "aws_api_gateway_rest_api" "api_gateway" {
  name        = "CrowdfundingAPI"
  description = "API Gateway for Crowdfunding Platform"
}

# Crear Lambda Function
resource "aws_lambda_function" "backend_lambda" {
  function_name = "BackendLambda"
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = "index.handler"
  runtime       = "nodejs14.x"

  # Suponiendo que tienes un archivo zip con el código
  filename         = "lambda_function_payload.zip"
  source_code_hash = filebase64sha256("lambda_function_payload.zip")

  environment {
    variables = {
      ENV = "prod"
    }
  }
}

# Crear EC2 Instance para Nodos de Ethereum
resource "aws_instance" "ethereum_node" {
  ami           = "ami-0c55b159cbfafe1f0"  # AMI de ejemplo, reemplaza con una válida
  instance_type = "t2.micro"
  key_name      = var.key_pair_name

  tags = {
    Name = "EthereumNode"
  }
}

# Crear RDS para Base de Datos
resource "aws_db_instance" "rds_instance" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t2.micro"
  name                 = "crowdfundingdb"
  username             = "admin"
  password             = var.db_password
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
}

# Crear DynamoDB
resource "aws_dynamodb_table" "dynamodb_table" {
  name           = "CrowdfundingTokens"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "TokenID"

  attribute {
    name = "TokenID"
    type = "S"
  }

  tags = {
    Name = "CrowdfundingTokens"
  }
}

# Crear SageMaker Notebook Instance
resource "aws_sagemaker_notebook_instance" "sagemaker_instance" {
  name          = "CrowdfundingSageMaker"
  instance_type = "ml.t2.medium"
  role_arn      = aws_iam_role.sagemaker_role.arn
}

# Crear roles IAM para Lambda y SageMaker
resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole",
  ]
}

resource "aws_iam_role" "sagemaker_role" {
  name = "sagemaker_execution_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "sagemaker.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSageMakerFullAccess",
  ]
}

# Crear CloudWatch y CloudTrail
resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/BackendLambda"
  retention_in_days = 14
}

resource "aws_cloudtrail" "cloudtrail" {
  name                          = "CrowdfundingTrail"
  s3_bucket_name                = aws_s3_bucket.frontend_bucket.bucket
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_logging                = true
}

