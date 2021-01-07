resource "aws_codebuild_project" "this" {
  name          = "test-project"
  description   = "test_codebuild_project"
  build_timeout = "5"
  service_role  = aws_iam_role.example.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }


  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:1.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name  = "SOME_KEY1"
      value = "SOME_VALUE1"
    }

    environment_variable {
      name  = "SOME_KEY2"
      value = "SOME_VALUE2"
      type  = "PARAMETER_STORE"
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "log-group"
      stream_name = "log-stream"
    }

  }

  source {
    type            = "GITHUB"
    location        = "https://github.com/sebmrgn/play.git"
    git_clone_depth = 1
    buildspec           = "template/buildspec.yml"

    git_submodules_config {
      fetch_submodules = true
    }
  }

  source_version = "master"

//  vpc_config {
//    vpc_id = aws_vpc.example.id
//
//    subnets = [
//      aws_subnet.example1.id,
//      aws_subnet.example2.id,
//    ]
//
//    security_group_ids = [
//      aws_security_group.example1.id,
//      aws_security_group.example2.id,
//    ]
//  }

  tags = {
    Environment = "Test"
  }
}