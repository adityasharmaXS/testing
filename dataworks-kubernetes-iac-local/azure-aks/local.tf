locals {
  tags = {
    Environment = "${var.environment_name}"
    Client      = "${var.client_name}"
    infra_name  = "${var.infra_name}"
    Terraform   = "true"
  }
}
