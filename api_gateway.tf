resource "aws_api_gateway_rest_api" "url_shortner_api" {
  name        = "URLShortener"
  description = "This is my API for url shortner"
}

resource "aws_api_gateway_deployment" "url_shortner_api_deployment" {
  depends_on = [
    aws_api_gateway_integration_response.url_shortner_post_api_response_integration,
    aws_api_gateway_integration_response.url_shortner_get_api_response_integration,
    aws_api_gateway_integration.root_get_integration
  ]
  rest_api_id = aws_api_gateway_rest_api.url_shortner_api.id
  triggers = {
    redeployment = sha1(
      jsonencode([
        file("root_get_method.tf"),
        file("url_shortner_post_method.tf"),
        file("url_shortner_get_method.tf"),
      ])
    )
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "url_shortner_api_stage" {
  deployment_id = aws_api_gateway_deployment.url_shortner_api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.url_shortner_api.id
  stage_name    = "dev"
}
