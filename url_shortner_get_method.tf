resource "aws_api_gateway_resource" "url_shortner_get_resource" {
  depends_on = [
    aws_api_gateway_rest_api.url_shortner_api
  ]
  rest_api_id = aws_api_gateway_rest_api.url_shortner_api.id
  parent_id   = aws_api_gateway_rest_api.url_shortner_api.root_resource_id
  path_part   = "{shortId}"
}

resource "aws_api_gateway_method" "url_shortner_get_method" {
  depends_on = [
    aws_api_gateway_resource.url_shortner_get_resource
  ]
  rest_api_id   = aws_api_gateway_rest_api.url_shortner_api.id
  resource_id   = aws_api_gateway_resource.url_shortner_get_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "url_shortner_get_integration" {
  depends_on = [
    aws_api_gateway_method.url_shortner_get_method
  ]
  rest_api_id             = aws_api_gateway_rest_api.url_shortner_api.id
  resource_id             = aws_api_gateway_resource.url_shortner_get_resource.id
  http_method             = aws_api_gateway_method.url_shortner_get_method.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = "arn:aws:apigateway:ap-south-1:dynamodb:action/GetItem"
  credentials             = aws_iam_role.url_shortner_api_role.arn

  request_templates = {
    "application/json" = <<EOF
{
  "Key": {
    "shortId": {
      "S": "$input.params().path.shortId"
    }
  },
  "TableName": "URL-Shortener"
}
EOF
  }
}

resource "aws_api_gateway_method_response" "url_shortner_get_response_302" {
  depends_on = [
    aws_api_gateway_method.url_shortner_get_method,
    aws_api_gateway_resource.url_shortner_get_resource
  ]
  rest_api_id         = aws_api_gateway_rest_api.url_shortner_api.id
  resource_id         = aws_api_gateway_resource.url_shortner_get_resource.id
  http_method         = aws_api_gateway_method.url_shortner_get_method.http_method
  response_parameters = { "method.response.header.Location" = false }
  status_code         = "302"
}

resource "aws_api_gateway_integration_response" "url_shortner_get_api_response_integration" {
  depends_on = [
    aws_api_gateway_integration.url_shortner_get_integration,
    aws_api_gateway_method_response.url_shortner_get_response_302
  ]
  rest_api_id       = aws_api_gateway_rest_api.url_shortner_api.id
  resource_id       = aws_api_gateway_resource.url_shortner_get_resource.id
  http_method       = aws_api_gateway_method.url_shortner_get_method.http_method
  status_code       = aws_api_gateway_method_response.url_shortner_get_response_302.status_code
  selection_pattern = "2\\d{2}"

  response_templates = {
    "application/json" = <<EOF
#set($DDBResponse = $input.path('$'))
#if ($DDBResponse.toString().contains("Item"))
#set($context.responseOverride.header.Location = $DDBResponse.Item.longURL.S)
#end
EOF
  }
}
