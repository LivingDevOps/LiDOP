terraform {
  backend "s3" {
    bucket = "lidopterraform"
    key    = "commonstate"
    region = "eu-central-1"
  }
}