# Empaquetar el código con archive_file
data "archive_file" "zip" {
  type        = "zip"
  source_dir  = "${path.module}/../../../lambdas/fileProcessor"
  output_path = "${path.module}/../../../.artifact/fileProcessor.zip"
}

resource "aws_iam_role" "lambda_exec" {
  name = "${var.function_name}-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy" "logs" {
  name = "${var.function_name}-logs"
  role = aws_iam_role.lambda_exec.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      Resource = "*"
    }]
  })
}

resource "aws_iam_role_policy" "publish" {
  name = "${var.function_name}-publish"
  role = aws_iam_role.lambda_exec.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = ["sns:Publish"],
        Resource = var.sns_topic_arn
      },
      {
        Effect   = "Allow",
        Action   = ["sqs:SendMessage"],
        Resource = var.sqs_queue_arn
      }
    ]
  })
}

resource "aws_iam_role_policy" "s3_read" {
  count = var.s3_read_enabled ? 1 : 0
  name  = "${var.function_name}-s3-read"
  role  = aws_iam_role.lambda_exec.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Action   = ["s3:GetObject", "s3:GetObjectVersion"],
      Resource = "${var.s3_bucket_arn}/*"
    }]
  })
}

resource "aws_lambda_function" "this" {
  function_name    = var.function_name
  role             = aws_iam_role.lambda_exec.arn
  handler          = "index.handler"
  runtime          = "nodejs18.x"
  filename         = data.archive_file.zip.output_path
  source_code_hash = data.archive_file.zip.output_base64sha256
  timeout          = 30
  memory_size      = 256
  architectures    = ["arm64"]

  environment {
    variables = var.environment
  }
}
