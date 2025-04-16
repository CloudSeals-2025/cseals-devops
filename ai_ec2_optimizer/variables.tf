variable "lambda_s3_bucket" {
  default = "ai-cloud-optimizer"
}

variable "lambda_s3_key" {
  default = "unused_ec2/predicted_unused_us-east-1.csv"
}

variable "aws_region" {
  default = "us-east-1"
}
