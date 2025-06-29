#Iam role for lambda
resource "aws_iam_role" "lambda_role" {
    name = "lambda_role"
    
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
        {
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Principal = {
            Service = "lambda.amazonaws.com"
            }
        },
        ]
    })
    }

    #iam policy for lambda
resource "aws_iam_policy" "lambda_policy" {
    name        = "lambda_policy"
    description = "Policy for Lambda function"
    
    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = [
                    "logs:CreateLogGroup",
                    "logs:CreateLogStream",
                    "logs:PutLogEvents"
                ]
                Effect   = "Allow"
                Resource = "*"
            }
        ]
    })
}

# Attach the policy to the role
resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
    role       = aws_iam_role.lambda_role.name
    policy_arn = aws_iam_policy.lambda_policy.arn
}

# Lambda function
resource "aws_lambda_function" "my_lambda" {    
    function_name = "my_lambda_function"
    role          = aws_iam_role.lambda_role.arn
    handler       = "index.handler"
    runtime       = "python3.8"

    # Assuming the code is in a file named lambda_function.zip in the current directory
    filename      = "lambda_function.zip"
    
    source_code_hash = filebase64sha256("lambda_function.zip")

    # Environment variables (optional)
    environment {
        variables = {
            MY_ENV_VAR = "some_value"
        }
    }
}