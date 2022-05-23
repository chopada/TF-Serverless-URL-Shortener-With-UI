# **Serverless URL Shortener With UI**

A serverless implementation of an URL Shortener Service with UI.

![abc](https://i.postimg.cc/0jRFJN1z/URL-Shortener-With-UI.gif)

## The AWS Serverless Ecosystem

> Serverless is a way to describe the services, practices, and strategies that enable you to build more agile applications so you can innovate and respond to change faster. With serverless computing, infrastructure management tasks like capacity provisioning and patching are handled by AWS, so you can focus on only writing code that serves your customers.

**Serverless Computing = FaaS [Functions as a Service] + BaaS [Backend as a Service]**

### Serverless Services of AWS

* **Compute:** AWS Lambda, AWS Fargate
* **Storage:** Amazon DynamoDB, Amazon S3, etc.
* **Application Integration:** Amazon API Gateway, etc.

## **Introduction**

We have developed an URL Shortener Service using various services of the AWS Serverless Ecosystem. We are going to focus mainly on the backend of the application.

To implement our project in a simplified way, we will use only the 3 most important services: the **AWS Lambda**, **API Gateway** and **DynamoDB**.

I have written it completely in **Terraform**

## Deployment Instructions

### Authentication

Create AWS Profile `terraform_admin`

```
$ aws configure --profile terraform_admin

AWS Access Key ID: yourID
AWS Secret Access Key: yourSecert
Default region name : aws-region
Default output format : env
```

### Deployment

Run following commands in root directory of project

###### Note: deploy.sh file is compatible for MacOS you can change it according to your OS

```
bash deploy.sh
```

Output

```
WEB_URL = "https://<API_ID>.execute-api.ap-south-1.amazonaws.com/dev/"
```

Open WEB_URL to your browser.

### Delete Deployment

Run following command

```
terraform destroy
```
