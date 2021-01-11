terraform {
  backend "s3" {
    bucket = "checkout-bucket2021"
    key    = "terraform.tfstate"
    region = "eu-west-1"
  }
}