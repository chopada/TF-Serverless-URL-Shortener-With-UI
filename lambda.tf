# Lambda
resource "aws_lambda_permission" "lambda_root_url_shortener_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_root_url_shortener.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.url_shortner_api.execution_arn}/*/*/*"
}

resource "aws_lambda_function" "lambda_root_url_shortener" {
  depends_on = [
    aws_iam_role.url_shortner_lambda_role
  ]
  filename      = "lambda.zip"
  function_name = "root_url_shortener"
  role          = aws_iam_role.url_shortner_lambda_role.arn
  handler       = "lambda/handler.rootUrlShortener"
  runtime       = "nodejs14.x"

  source_code_hash = filebase64sha256("lambda.zip")
}
