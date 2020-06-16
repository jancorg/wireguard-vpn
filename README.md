deploys a wireguard vpn server with coredns and dynamic dns client. Its mission is to exit to internet using the different locations that any configured datacenter can provide with.
coredns and ddclient are optional, they can be skipped usin ansible tags in `packer.json` or `ansible` command

it currently support terraform and packer files for:
- scaleway
- upcloud

but other providers can be easily used

whilst playbook automatically generate keys for server and client by default, private keys can be manually set to reuse configurations


### steps

- Choose a location (loc/zone) and set it up in terraform files. (cheaper image will work)
- Setup variables
- deploy
- scan qr codes or copy the config in your device

### variables
some of them are explained here, check ansible roles for more configuration options

```
domain: domain.example.com              # endpoint: use a domain or public ip if not available
server_internal_ip: 10.123.123.1        # vpn server internal ip

ddns_login: login                       # optional # dyndns login
ddns_password: password                 # optional # dyndns passwd
ddns_server: update.example.org         # optional # dyndns server
ddns_domain: domain.example.com         # optional # domain to be updated

# vpn_privkey:                          # optional # server privkey, set to fix
vpn_endpoint: domain.example.com        # ip showed on qr codes and config files. either a domain or an ip
vpn_ipv4: 10.123.123.1                  # vpn server internal ip
vpn_allowed_ips: "0.0.0.0/0, ::/0"      # default value
vpn_out_iface: ens2                     # defaults to eth0
vpn_dns_server: 10.123.123.1            # either a dns server or server ip if coredns is not set

peers:
  peer1:
    ipv4: 10.123.123.2                  # only mandatory attr
  peer3:
    privkey: AKEY                       # optional, set to fix
    ipv4: 10.123.123.4

coredns_bind_addr: 10.123.123.1         # server internal ip

```

### use examples

packer
```
$ cd  infra/scw
$ packer build packer.json
$ terraform apply                        # init if needed
$ terraform output ansible-host > hosts
$ cd ../../ansible
$ ansible-playbook -i ../infra/scw/hosts site.yml --skip-tags install
```

one use server
```
$ terraform apply             # init if needed
$ terraform output ansible-host > hosts
$ cd ../../ansible
$ ansible-playbook -i ../infra/scw/hosts site.yml
```

update configuration
```
$ ansible-playbook -i ../infra/scw/hosts site.yml -t setup
```

launch for single use
```
$ terraform apply             # init if needed
$ terraform output ansible-host > hosts
$ cd ../../ansible
$ ansible-playbook -i ../infra/scw/hosts site.yml
```

no coredns or dyndns client
```
$ terraform apply             # init if needed
$ terraform output ansible-host > hosts
$ cd ../../ansible
$ ansible-playbook -i ../infra/scw/hosts site.yml --skip-tags corends,ddclient
```

### destroy

```
$ cd  infra/scw
$ terraform destroy
$ rm hosts
```
