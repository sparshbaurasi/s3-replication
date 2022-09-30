variable "provider_region" {
    default = "us-east-1"
}
variable "role_name" {
    type = string
    default = "s3_replication_role"
}
variable "role_policy_name" {
    type = string
    default = "s3_replication_role_policy"
}
variable "destination_bucket_name" {
    # type = string
}

variable "bucket_versioning_status_toggle" {
    type = string
    default = "Enabled"
}
variable "source_bucket_name" {
    type = string
}
# variable "source_bucket_acl_status" {
#     default = "private"
# }
variable "replication_rule_id" {
    type = string
    default = "id"
}
variable "replication_rule_status" {
    type = string
    default = "Enabled"
}
variable "replication_rule_destination_storage_class" {
   default = "STANDARD"
}

variable "Iam_role_trust_policy" {
    default = <<POLICY

{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "s3.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}