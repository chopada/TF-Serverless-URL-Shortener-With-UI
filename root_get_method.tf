resource "aws_api_gateway_method" "root_get_method" {
  depends_on = [
    aws_api_gateway_rest_api.url_shortner_api
  ]
  rest_api_id   = aws_api_gateway_rest_api.url_shortner_api.id
  resource_id   = aws_api_gateway_rest_api.url_shortner_api.root_resource_id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "root_get_integration" {
  depends_on = [
    aws_api_gateway_method.root_get_method,
    aws_lambda_function.lambda_root_url_shortener
  ]
  rest_api_id             = aws_api_gateway_rest_api.url_shortner_api.id
  resource_id             = aws_api_gateway_rest_api.url_shortner_api.root_resource_id
  http_method             = aws_api_gateway_method.root_get_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_root_url_shortener.invoke_arn
}

output "WEB_URL" {
  value = "${aws_api_gateway_stage.url_shortner_api_stage.invoke_url}/"
}
