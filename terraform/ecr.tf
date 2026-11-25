resource "aws_ecr_repository" "my_ecr_repository" {
  name                 = "devops-bootcamp/final-project-harith-mn"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
