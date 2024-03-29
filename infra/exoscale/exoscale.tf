variable "exoscale_api_key" {
  type        = string
  default = "exoscale api key"
}
variable "exoscale_api_secret" {
  type        = string
  default = "exoscale api secret"
}
provider "exoscale" {
  key    = var.exoscale_api_key
  secret = var.exoscale_api_secret
}

locals {
  zone = "ch-gva-2"
}

data "exoscale_compute_template" "ubuntu" {
  zone = local.zone
  name = "Linux Ubuntu 20.04 LTS 64-bit"
}

resource "exoscale_compute" "ubuntu-wireguard" {
  zone         = local.zone
  display_name = "ubuntu-wireguard"
  size         = "Micro"
  template_id  = data.exoscale_compute_template.ubuntu.id
  disk_size    = 10
  security_groups = [exoscale_security_group.vpn.name]
  key_pair = "wireguard"
  user_data    = <<EOF
#cloud-config
package_upgrade: true
EOF
}


resource "exoscale_security_group" "vpn" {
  name        = "wireguard"
  description = "allow vpn traffic"

}

resource "exoscale_security_group_rules" "vpn" {
  security_group = exoscale_security_group.vpn.name

  ingress {
    protocol = "UDP"
    cidr_list = ["0.0.0.0/0", "::/0"]
    ports = [51820]
  }

  ingress {
    protocol = "TCP"
    cidr_list = ["0.0.0.0/0", "::/0"]
    ports = [22]
  }
}


output "ansible_host" {
  value       = "[vpn]\n${exoscale_compute.ubuntu-wireguard.ip_address} ansible_user=root"
}
