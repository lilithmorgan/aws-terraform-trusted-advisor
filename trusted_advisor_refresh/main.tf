module "trusted-advisor-refresh" {
  source             = "trussworks/trusted-advisor-refresh/aws"
  version            = "1.0.0"
  environment        = "prod"
  interval_minutes   = "5"
  s3_bucket          = "lilith-tfstate"
  version_to_deploy  = "1.0"
}
