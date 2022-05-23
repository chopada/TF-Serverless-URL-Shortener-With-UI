resource "aws_api_gateway_resource" "url_shortner_post_resource" {
  depends_on = [
    aws_api_gateway_rest_api.url_shortner_api
  ]
  rest_api_id = aws_api_gateway_rest_api.url_shortner_api.id
  parent_id   = aws_api_gateway_rest_api.url_shortner_api.root_resource_id
  path_part   = "url-shortener"
}

resource "aws_api_gateway_method" "url_shortner_post_method" {
  depends_on = [
    aws_api_gateway_resource.url_shortner_post_resource
  ]
  rest_api_id   = aws_api_gateway_rest_api.url_shortner_api.id
  resource_id   = aws_api_gateway_resource.url_shortner_post_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "url_shortner_post_integration" {
  depends_on = [
    aws_api_gateway_method.url_shortner_post_method
  ]
  rest_api_id             = aws_api_gateway_rest_api.url_shortner_api.id
  resource_id             = aws_api_gateway_resource.url_shortner_post_resource.id
  http_method             = aws_api_gateway_method.url_shortner_post_method.http_method
  integration_http_method = aws_api_gateway_method.url_shortner_post_method.http_method
  type                    = "AWS"
  uri                     = "arn:aws:apigateway:ap-south-1:dynamodb:action/UpdateItem"
  credentials             = aws_iam_role.url_shortner_api_role.arn

  request_templates = {
    "application/json" = <<EOF
    {
        "TableName": "URL-Shortener",
        "ConditionExpression": "attribute_not_exists(id)",
        "Key": {
            "shortId": {
                "S": $input.json('$.shortURL')
            }
        },
        "ExpressionAttributeNames": {
            "#u": "longURL",
            "#o": "owner"
        },
        "ExpressionAttributeValues": {
            ":u": {
                "S": $input.json('$.longURL')
            },
            ":o": {
                "S":  $input.json('$.owner')
            }
        },
        "UpdateExpression": "SET #u = :u, #o = :o",
        "ReturnValues": "ALL_NEW"
    }
    EOF
  }
}

resource "aws_api_gateway_method_response" "url_shortner_post_response_200" {
  depends_on = [
    aws_api_gateway_method.url_shortner_post_method
  ]
  rest_api_id = aws_api_gateway_rest_api.url_shortner_api.id
  resource_id = aws_api_gateway_resource.url_shortner_post_resource.id
  http_method = aws_api_gateway_method.url_shortner_post_method.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "url_shortner_post_api_response_integration" {
  depends_on = [
    aws_api_gateway_integration.url_shortner_post_integration,
    aws_api_gateway_method_response.url_shortner_post_response_200
  ]
  rest_api_id = aws_api_gateway_rest_api.url_shortner_api.id
  resource_id = aws_api_gateway_resource.url_shortner_post_resource.id
  http_method = aws_api_gateway_method.url_shortner_post_method.http_method
  status_code = aws_api_gateway_method_response.url_shortner_post_response_200.status_code

  # Transforms the backend JSON response to XML
  response_templates = {
    "application/json" = <<EOF
#set($https = "https://")
#set($slash = "/")
#set($DDBResponse = $input.path('$'))
{
    "shortURL": "$https$context.domainName$slash$context.stage$slash$DDBResponse.Attributes.shortId.S"
}
        EOF
  }
}
