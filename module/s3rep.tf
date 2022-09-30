resource "aws_iam_role" "test_role_s3" {
  name = var.role_name
  assume_role_policy = var.Iam_role_trust_policy
}
data "template_file" "mypolicy" {
  template = file("/module/policy.tpl")

  vars = {
    source_bucket_name=var.source_bucket_name
    destination_bucket_name = var.destination_bucket_name 
  }
}

resource "aws_iam_policy" "test_role_pol_s3" {
  name = var.role_policy_name
  policy = data.template_file.mypolicy.rendered
}



resource "aws_iam_role_policy_attachment" "test-role-s3" {
  role       = aws_iam_role.test_role_s3.name
  policy_arn = aws_iam_policy.test_role_pol_s3.arn
}

resource "aws_s3_bucket" "destination_bucket" {
  bucket = var.destination_bucket_name
}

resource "aws_s3_bucket_versioning" "destination_bucket_versioning" {
  bucket = aws_s3_bucket.destination_bucket.id
  versioning_configuration {
    status = var.bucket_versioning_status_toggle
  }
  depends_on = [aws_s3_bucket.destination_bucket]
}

# resource "aws_s3_bucket_acl" "source_bucket_acl" {
#   bucket =  var.source_bucket_name
#   acl    = var.source_bucket_acl_status
#   depends_on = [aws_s3_bucket.destination_bucket]
# }

resource "aws_s3_bucket_versioning" "source_bucket_versioning" {
  bucket = var.source_bucket_name
  versioning_configuration {
    status = var.bucket_versioning_status_toggle
  }
  depends_on = [aws_s3_bucket.destination_bucket]
}

resource "aws_s3_bucket_replication_configuration" "replication" {
  depends_on = [aws_s3_bucket_versioning.source_bucket_versioning]

  role   = aws_iam_role.test_role_s3.arn
  bucket = var.source_bucket_name

  rule {
    id = var.replication_rule_id
    status = var.replication_rule_status
    destination {
      bucket        = aws_s3_bucket.destination_bucket.arn
      storage_class = var.replication_rule_destination_storage_class
    }
  }
}