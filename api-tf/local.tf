locals {
  workspace     = split("-", terraform.workspace)
  name          = "test-${var.context}"
  vpc_link_name = "test-link-${var.context}"
  tags          = merge(var.tags, { Name = local.name })
}