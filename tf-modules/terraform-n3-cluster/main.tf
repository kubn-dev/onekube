resource "scaleway_k8s_cluster" "main" {
  name                        = "${data.scaleway_account_project.main.name}-cluster"
  version                     = "1.32"
  cni                         = "cilium"
  private_network_id          = scaleway_vpc_private_network.main.id
  delete_additional_resources = true
  auto_upgrade {
    enable                        = true
    maintenance_window_start_hour = "3"
    maintenance_window_day        = "sunday"
  }
  tags       = [data.scaleway_account_project.main.name, "terraform"]
  depends_on = [scaleway_vpc_gateway_network.main]
}

resource "scaleway_k8s_pool" "main" {
  cluster_id             = scaleway_k8s_cluster.main.id
  name                   = "${data.scaleway_account_project.main.name}-pool"
  node_type              = "DEV1-M"
  size                   = 3
  autoscaling            = false
  autohealing            = true
  root_volume_size_in_gb = 20
  public_ip_disabled     = true
  tags                   = [data.scaleway_account_project.main.name, "terraform"]
}
