locals {
  package_file = "${local.name}-${var.release}.zip"
  name         = "${var.name}-athena-partitions"
}