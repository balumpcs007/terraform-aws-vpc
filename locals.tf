locals {
  comman_tags = {
    Project = var.project_name
    Environmet = var.environmet
    Terraform = true
  }
  comman_name_suffix = "${var.project_name}-${var.environmet}"
  aws_availability_zones = slice(data.aws_availability_zones.available.names, 0,2)
}