resource "aws_vpc" "main" {
  cidr_block = var.cidr
  instance_tenancy = "default"

  enable_dns_hostnames = true
  enable_dns_support = true

  tags = merge(
    local.common_tags,
    {
        Name = "${var.project}-${var.environment}"
    },
    var.vpc_tags
  )
}