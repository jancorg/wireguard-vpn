variable "scw_organization_id" {
  type        = string
  description = "scaleway organization ID" 
}

variable "scw_api_token" {
  type        = string
  description = "scaleway api secret" 
}

variable "scw_access_key" {
  type        = string
  description = "scaleway access_key" 
}

provider "scaleway" {
  access_key      = var.scw_access_key
  organization_id = var.scw_organization_id
  secret_key      = var.scw_api_token
  zone            = "fr-par-1"
  region          = "fr-par"
}

resource "scaleway_instance_ip" "ip" {
}

data "scaleway_image" "ubuntu-wireguard" {
  architecture = "x86_64"
  name         = "ubuntu-wireguard"
}

# resource "scaleway_instance_volume" "data" {
#   size_in_gb = 40
#   type = "l_ssd"
# }

resource "scaleway_instance_server" "ubuntu-wireguard" {
  name  = "ubuntu-wireguard"
  image = data.scaleway_image.ubuntu-wireguard.id
  ip_id = scaleway_instance_ip.ip.id
  type  = "DEV1-M"
#  provisioner "remote-exec" {
#    inline = ["echo done"]
#  }
}

resource "scaleway_instance_security_group" "vpn" {
  name        = "wireguard"
  description = "allow vpn traffic"

  inbound_default_policy  = "drop"
  outbound_default_policy = "accept"

  inbound_rule {
    action   = "accept"
    port     = "51820"
    protocol = "UDP"
  }

  inbound_rule {
    action   = "accept"
    port     = "22"
    protocol = "TCP"
  }
}

output "ansible_host" {
  value       = "[vpn]\n${scaleway_instance_server.ubuntu-wireguard.public_ip} ansible_user=root"
}
