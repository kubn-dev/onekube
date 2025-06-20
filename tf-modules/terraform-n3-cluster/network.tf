resource "scaleway_vpc_private_network" "main" {
  name   = "${data.scaleway_account_project.main.name}-vpc"
  vpc_id = "${var.scw_region}/${var.scw_vpc_id}"
  tags   = [data.scaleway_account_project.main.name, "terraform"]
}

resource "scaleway_vpc_public_gateway" "main" {
  name = "${data.scaleway_account_project.main.name}-gw"
  type = "VPC-GW-S"
  tags = ["demo", "terraform"]
}

resource "scaleway_vpc_gateway_network" "main" {
  gateway_id         = scaleway_vpc_public_gateway.main.id
  private_network_id = scaleway_vpc_private_network.main.id
  ipam_config {
    push_default_route = true
  }
}

# TODO: CREATE VPC
