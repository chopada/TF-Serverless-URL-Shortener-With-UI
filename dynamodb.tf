resource "aws_dynamodb_table" "url-shortner-dynamodb-table" {
  name         = "URL-Shortener"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "shortId"

  attribute {
    name = "shortId"
    type = "S"
  }

  tags = {
    Name        = "URL-Shortener"
    Environment = "development"
  }
}
