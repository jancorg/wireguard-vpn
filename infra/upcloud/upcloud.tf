provider "upcloud" {
  # Your UpCloud credentials are read from the environment variables
  # export UPCLOUD_USERNAME="Username for Upcloud API user"
  # export UPCLOUD_PASSWORD="Password for Upcloud API user"
}

resource "upcloud_server" "ubuntu-wireguard" {
  hostname = "ubuntu-wireguard"
  zone = "uk-lon1"
  plan = "1xCPU-1GB"
  storage_devices {
    size = 25
    # Template UUID for Ubuntu 20.04
    storage = "01000000-0000-4000-8000-000030200200"
    tier   = "maxiops"
    action = "clone"
  }

  login {
    user = "root"
    keys = [
      "ssh-rsa AAAA",
    ]
    create_password = false
  }

  connection {
    host        = self.ipv4_address
    type        = "ssh"
    user        = "root"
    private_key = file("~/.ssh/id_rsa")
  }
}


output "ansible_host" {
  value       = "[vpn]\n${upcloud_server.ubuntu-wireguard.ipv4_address} ansible_user=root"
}

# resource "upcloud_firewall_rule" "ssh" {
#       server_id                 = upcloud_server.ubuntu-wireguard.id
#       action                    = "accept"
#       comment                   = "Allow SSH from all"
#       destination_port_end      = "22"
#       destination_port_start    = "22"
#       direction                 = "in"
#       family                    = "IPv4"
#       position                  = "1"
#       protocol                  = "tcp"
# }
# resource "upcloud_firewall_rule" "vpn" {
#       server_id                 = upcloud_server.ubuntu-wireguard.id
#       action                    = "accept"
#       comment                   = "Allow wireguard from all"
#       destination_port_end      = "51820"
#       destination_port_start    = "51820"
#       direction                 = "in"
#       family                    = "IPv4"
#       position                  = "2"
#       protocol                  = "udp"
# }
# resource "upcloud_firewall_rule" "drop all" {
#       server_id                 = upcloud_server.ubuntu-wireguard.id
#       action                    = "drop"
#       comment                   = "drop from all"
#       direction                 = "in"
#       family                    = "IPv4"
#       position                  = "3"
# }