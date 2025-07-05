terraform {
  backend "s3" {
    bucket         = "lesson5-tfstate-bucket"
    key            = "lesson-5/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
