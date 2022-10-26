data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "./boto"
  output_path = "lambda.zip"
}
