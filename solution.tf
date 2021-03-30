resource "aws_s3_bucket" "solution" {
  bucket_prefix = replace(var.name, "upload", "website")
  force_destroy = true
  acl           = "public-read"

  website {
    error_document = "error.html"
    index_document = "index.html"
  }
}

resource "aws_s3_bucket_policy" "solution" {
  bucket = aws_s3_bucket.solution.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "PublicReadGetObject",
        "Effect" : "Allow",
        "Principal" : "*",
        "Action" : [
          "s3:GetObject"
        ],
        "Resource" : [
          "${aws_s3_bucket.solution.arn}/*"
        ]
      }
    ]
  })
}

resource "aws_s3_bucket_object" "html" {
  for_each     = fileset(path.module, "website/*.html")
  bucket       = aws_s3_bucket.solution.id
  key          = each.value
  source       = "${path.module}/${each.value}"
  content_type = "text/html"
}

resource "aws_s3_bucket_object" "css" {
  for_each     = fileset(path.module, "website/css/**")
  bucket       = aws_s3_bucket.solution.id
  key          = each.value
  source       = "${path.module}/${each.value}"
  content_type = "text/html"
}

resource "aws_s3_bucket_object" "images" {
  for_each = fileset(path.module, "website/images/**")
  bucket   = aws_s3_bucket.solution.id
  key      = each.value
  source   = "${path.module}/${each.value}"
}

resource "aws_s3_bucket_object" "js" {
  for_each     = fileset(path.module, "website/js/**")
  bucket       = aws_s3_bucket.solution.id
  key          = each.value
  source       = "${path.module}/${each.value}"
  content_type = "text/html"
}

resource "aws_s3_bucket_object" "fonts" {
  for_each = fileset(path.module, "website/fonts/**")
  bucket   = aws_s3_bucket.solution.id
  key      = each.value
  source   = "${path.module}/${each.value}"
}
