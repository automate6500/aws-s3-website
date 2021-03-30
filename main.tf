provider "aws" {
  region = "us-west-2"
}

variable "name" {
  type    = string
  default = "globomantics-upload-"
}

resource "aws_s3_bucket" "lab" {
  bucket_prefix = var.name
  force_destroy = true
}

data "archive_file" "lab" {
  type        = "zip"
  source_dir  = "${path.module}/website"
  output_path = "${path.module}/website.zip"
}

resource "aws_s3_bucket_object" "lab" {
  bucket = aws_s3_bucket.lab.id
  key    = "website.zip"
  source = "${path.module}/website.zip"
}
