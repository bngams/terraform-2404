# define aws region 
variable "region" {
  default = "eu-west-3"
}

variable "bucket_name" {
    description = "Name of the s3 bucket. Must be unique."
    type = string
}


# S3 static website bucket

resource "aws_s3_bucket" "my-static-website" {
  bucket = var.bucket_name # give a unique bucket name
  tags = {
    Name = "my-static-website"
  }
}

resource "aws_s3_bucket_website_configuration" "my-static-website" {
  bucket = aws_s3_bucket.my-static-website.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

resource "aws_s3_bucket_ownership_controls" "my-static-website" {
  bucket = aws_s3_bucket.my-static-website.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "my-static-website" {
  bucket = aws_s3_bucket.my-static-website.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "my-static-website" {
  depends_on = [
    aws_s3_bucket_ownership_controls.my-static-website,
    aws_s3_bucket_public_access_block.my-static-website,
  ]

  bucket = aws_s3_bucket.my-static-website.id
  acl    = "public-read"
}

resource "aws_s3_object" "example" {
  key                    = "index.html"
  bucket                 = aws_s3_bucket.my-static-website.id
  source                 = "${path.module}/index.html"
  server_side_encryption = "AES256"
}

# S3 bucket policy
resource "aws_s3_bucket_policy" "bucket-policy" {
  bucket = aws_s3_bucket.my-static-website.id

  policy = <<POLICY
    {
    "Id": "Policy",
    "Statement": [
        {
        "Action": [
            "s3:GetObject"
        ],
        "Effect": "Allow",
        "Resource": "arn:aws:s3:::${aws_s3_bucket.my-static-website.bucket}/*",
        "Principal": {
            "AWS": [
            "*"
            ]
        }
        }
    ]
    }
    POLICY
} 

# s3 static website url

output "website_url_manual" {
  value = "http://${aws_s3_bucket.my-static-website.bucket}.s3-website.${var.region}.amazonaws.com"
}

output "website_url" {
  value = aws_s3_bucket.my-static-website.bucket_regional_domain_name
}