resource "aws_ecr_repository" "image-repo" {
  name                 = "simple-website"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
}