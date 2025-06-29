resource "aws_s3_bucket" "test_bucket" {
  bucket = "my-unique-bucket-name-7998498853"
  acl    = "private"

  tags = {
    Name        = "MyTestBucket"
   
  }
  
}

# upload lambda function code to S3 bucket
resource "aws_s3_bucket_object" "lambda_function" {
  bucket = aws_s3_bucket.test_bucket.id
 key    = "lambda_function.zip"
  source = "lambda_function.zip"
#   etag   = filemd5("lambda_function.zip")
}

#iam role for lambda function
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
        }
        ]
    })
    }


#attch policy to the role
resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
    role       = aws_iam_role.lambda_role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}   

#lambda function
resource "aws_lambda_function" "test_lambda" {

    function_name = "test_lambda_function"
    role          = aws_iam_role.lambda_role.arn
    handler       = "lambda_function.lambda_handler"
    runtime       = "python3.8"
    
    s3_bucket     = aws_s3_bucket.test_bucket.id
    s3_key        = aws_s3_bucket_object.lambda_function.key
    
    source_code_hash = filebase64sha256("lambda_function.zip")
    
    
    }