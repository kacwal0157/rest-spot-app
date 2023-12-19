provider "aws" {
  version                 = "~> 2.0"
  region                  = var.region
}

terraform {
  backend "s3" {
    bucket = "rest-spot-terraform-state"
    key    = "services/platepreviewfe"
    region = "eu-central-1"
  }
}



module "template_files" {
  source  = "apparentlymart/dir/template"
  version = "1.0.0"

  base_dir      = "${path.module}/../../build/web"
  template_vars = {}
  # Optionally pass in any values to make available in template files.
}

resource "aws_s3_bucket_object" "dist_afore" {
  for_each = module.template_files.files

  bucket = "platepreview.com"
  key    = each.key
  source = each.value.source_path
  etag   = each.value.digests.md5
  content_type = each.value.content_type
  acl = "public-read"
}


