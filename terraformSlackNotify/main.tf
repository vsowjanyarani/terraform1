resource "aws_iam_role" "lambda_role" {
 count  = var.create_function ? 1 : 0
 name   = var.iam_role_lambda
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
}
 
# Generating the IAM Policy document in JSON format.
 
data "aws_iam_policy_document" "doc" {
  statement {
  actions    = var.actions
  effect     = "Allow"
  resources  = ["*"]
    }
}
 
# Creating IAM policy for AWS lambda function using previously generated JSON
 
resource "aws_iam_policy" "iam-policy" {
 count        = var.create_function ? 1 : 0
  name         = var.iam_policy_name
  path         = "/"
  description  = "IAM policy for logging from a lambda"
  policy       = data.aws_iam_policy_document.doc.json
}
 
# Attaching IAM policy on the newly created on IAM role.
 
resource "aws_iam_role_policy_attachment" "policy_attach" {
  count       = var.create_function ? 1 : 0
  role        = join("", aws_iam_role.lambda_role.*.name)
  policy_arn  = join("", aws_iam_policy.iam-policy.*.arn)
}
 
resource "aws_lambda_layer_version" "layer_version" {
  count                  = length(var.names) > 0 && var.create_function ? length(var.names) : 0
  filename              = length(var.file_name) > 0 ?  element(var.file_name,count.index) : null
  layer_name          = element(var.names, count.index)
  compatible_runtimes = element(var.compatible_runtimes, count.index)
}
 
# Generates an archive from content, a file, or directory of files.
 
data "archive_file" "default" {
  count            = var.create_function && var.filename != null ? 1 : 0
  type              = "zip"
  source_dir     = "${path.module}/files/"
  output_path  = "${path.module}/myzip/python.zip"
}
 
# Create a lambda function
 
resource "aws_lambda_function" "lambda-func" {
  count                           = var.create_function ? 1 :0
  filename                       = var.filename != null ? "${path.module}/myzip/python.zip"  : null
  function_name             = var.function_name
  role                               = join("",aws_iam_role.lambda_role.*.arn)
  handler                         = var.handler
  layers                            = aws_lambda_layer_version.layer_version.*.arn
  runtime                        = var.runtime
  depends_on                 = [aws_iam_role_policy_attachment.policy_attach]
}
 
# Giving permssions to cloudwatch event, SNS or S3 to access the Lambda function.
 
resource "aws_lambda_permission" "default" {
  count   = length(var.lambda_actions) > 0 && var.create_function ? length(var.lambda_actions) : 0
  action        = element(var.lambda_actions,count.index)
  function_name = join("",aws_lambda_function.lambda-func.*.function_name)
  principal     = element(var.principal,count.index)
}
