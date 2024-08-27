output "frontend_bucket_url" {
  description = "The URL for the S3 static website"
  value       = aws_s3_bucket.frontend_bucket.website_endpoint
}

output "api_gateway_id" {
  description = "The ID of the API Gateway"
  value       = aws_api_gateway_rest_api.api_gateway.id
}

output "ethereum_node_public_ip" {
  description = "The public IP of the Ethereum node EC2 instance"
  value       = aws_instance.ethereum_node.public_ip
}

output "rds_endpoint" {
  description = "The RDS endpoint"
  value       = aws_db_instance.rds_instance.endpoint
}
