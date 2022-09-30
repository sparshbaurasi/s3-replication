module "my-s3-replication" {
    source = "./module"
    destination_bucket_name="Your_Destination_Bucket_Name"
    source_bucket_name="Your_Source_Bucket_Name"
}

