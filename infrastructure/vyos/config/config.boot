container {
    name bind {
        cap-add net-bind-service
        command "/usr/sbin/named -4 -f -c /etc/bind/named.conf -u bind"
        image docker.io/internetsystemsconsortium/bind9:9.19
        memory 0
        network services {
            address 192.168.5.2
        }
        restart on-failure
        shared-memory 0
        volume cache {
            destination /var/cache/bind
            mode rw
            source /tmp/bind/cache
        }
        volume config {
            destination /etc/bind
            mode ro
            source /config/containers/bind/config
        }
    }
    name cloudflare-ddns {
        allow-host-networks
        environment CF_API_TOKEN {
            value "${SECRET_CLOUDFLARE_DYNDNS_TOKEN}"
        }
        environment DOMAINS {
            value ipv4."${SECRET_DOMAIN}"
        }
        environment IP6_PROVIDER {
            value none
        }
        environment TZ {
            value "${TIMEZONE}"
        }
        gid 1000
        image docker.io/favonia/cloudflare-ddns:1.9.4
        memory 0
        restart on-failure
        shared-memory 0
        uid 1000
    }
    name haproxy-k8s-api {
        image docker.io/library/haproxy:2.8.0
        memory 0
        network services {
            address 192.168.5.3
        }
        restart on-failure
        shared-memory 0
        volume config {
            destination /usr/local/etc/haproxy/haproxy.cfg
            mode ro
            source /config/containers/haproxy/config/haproxy.cfg
        }
    }
    name omada-controller {
        environment TZ {
            value "${TIMEZONE}"
        }
        environment MANAGE_HTTP_PORT {
            value 8088
        }
        environment MANAGE_HTTPS_PORT {
            value 8043
        }
        environment PORTAL_HTTP_PORT {
            value 8088
        }
        environment PORTAL_HTTPS_PORT {
            value 8843
        }
        environment SHOW_SERVER_LOGS {
            value true
        }
        environment SHOW_MONGODB_LOGS {
            value true
        }
        environment PGID {
            value 1000
        }
        environment PUID {
            value 1000
        }
        image docker.io/mbentley/omada-controller:5.9
        memory 0
        network services {
            address 192.168.5.4
        }
        restart on-failure
        shared-memory 0
        volume data {
            destination /opt/tplink/EAPController/data
            mode rw
            source /tmp/omada/data
        }
        volume log {
            destination /opt/tplink/EAPController/logs
            mode rw
            source /tmp/omada/data
        }
    }
    network containers {
        description "Network for VyOS containers"
        prefix 192.168.5.0/24
    }
}
firewall {
    all-ping enable
    broadcast-ping disable
    group {
        address-group k8s_nodes {
            address 192.168.20.5
            address 192.168.20.6
            address 192.168.20.7
            address 192.168.20.8
            address 192.168.20.9
            address 192.168.20.10
        }
        address-group k8s_api {
            address 192.168.5.2
        }
        address-group k8s_ingress {
            address 192.168.21.10
        }
        address-group k8s_services {
            address 10.43.0.0/16
        }
        address-group tplink_devices {
            address 192.168.10.2
            address 192.168.10.3
            address 192.168.10.4
        }
        address-group ios_devices {
            address 192.168.50.2
            address 192.168.50.3
            address 192.168.50.4
            address 192.168.50.5
            address 192.168.50.6
            address 192.168.50.7
            address 192.168.50.8
            address 192.168.50.9
            address 192.168.50.10
        }
        address-group nas {
            address 192.168.20.14
        }
        network-group k8s_cluster {
            address 10.42.0.0/16
        }
        network-group k8s_services {
            address 10.43.0.0/16
        }
        port-group wireguard {
            port 51820
        }
    }
    name lan-local {
        default-action accept
        description "From LAN to LOCAL"
        enable-default-log
    }
    name lan-wan {
        default-action accept
        description "From LAN to WAN"
        enable-default-log
    }
    name local-lan {
        default-action accept
        description "From LOCAL to LAN"
        enable-default-log
    }
    name local-wan {
        default-action accept
        description "From LOCAL to WAN"
        enable-default-log
    }
    name wan-lan {
        default-action drop
        description "From WAN to LAN"
        enable-default-log
    }
    name wan-local {
        default-action drop
        description "From WAN to LOCAL"
        enable-default-log
    }
    state-policy {
        established {
            action accept
        }
        invalid {
            action drop
        }
        related {
            action accept
        }
    }
    zone lan {
        default-action drop
        description "LAN backbone"
        from local {
            firewall {
                name local-lan
            }
        }
        from wan {
            firewall {
                name wan-lan
            }
        }
        interface eth1
    }
    zone local {
        default-action drop
        description "Local router zone"
        from lan {
            firewall {
                name lan-local
            }
        }
        from wan {
            firewall {
                name wan-local
            }
        }
    }
    zone wan {
        default-action drop
        description WAN
        from lan {
            firewall {
                name lan-wan
            }
        }
        from local {
            firewall {
                name local-wan
            }
        }
        interface eth0
    }
}
interfaces {
    ethernet eth0 {
        address dhcp
        description WAN
        hw-id EA:81:76:6F:27:EC
        mtu 1500
    }
    ethernet eth1 {
        address 192.168.0.1/24
        description LAN
        hw-id 16:D4:A5:2C:FC:83
        vif 10 {
            description MGMT
            address 192.168.10.1/24
        }
        vif 20 {
            description SERVERS
            address 192.168.20.1/24
        }
        vif 30 {
            description IOT
            address 192.168.30.1/24
        }
        vif 40 {
            description GUEST
            address 192.168.40.1/24
        }
        vif 50 {
            description TRUSTED
            address 192.168.50.1/24
        }
    }
    loopback lo{
    }
}
nat {
    destination {
        rule 104 {
            description "Force NTP for LAN"
            destination {
                address !192.168.0.1
                port 123
            }
            inbound-interface eth1
            protocol udp
            translation {
                address 192.168.0.1
                port 123
            }
        }
        rule 105 {
            description "Force NTP for MGMT"
            destination {
                address !192.168.10.1
                port 123
            }
            inbound-interface eth1.10
            protocol udp
            translation {
                address 192.168.10.1
                port 123
            }
        }
        rule 106 {
            description "Force NTP for SERVERS"
            destination {
                address !192.168.20.1
                port 123
            }
            inbound-interface eth1.20
            protocol udp
            translation {
                address 192.168.20.1
                port 123
            }
        }
        rule 107 {
            description "Force NTP for IOT"
            destination {
                address !192.168.30.1
                port 123
            }
            inbound-interface eth1.30
            protocol udp
            translation {
                address 192.168.30.1
                port 123
            }
        }
        rule 108 {
            description "Force NTP for GUEST"
            destination {
                address !192.168.40.1
                port 123
            }
            inbound-interface eth1.40
            protocol udp
            translation {
                address 192.168.40.1
                port 123
            }
        }
        rule 109 {
            description "Force NTP for TRUSTED"
            destination {
                address !192.168.50.1
                port 123
            }
            inbound-interface eth1.50
            protocol udp
            translation {
                address 192.168.50.1
                port 123
            }
        }
        rule 110 {
            description "Force NTP for Wireguard Trusted"
            destination {
                address !192.168.1.1
                port 123
            }
            inbound-interface wg0
            protocol udp
            translation {
                address 192.168.1.1
                port 123
            }
        }
    }
    source {
        rule 100 {
            description "ALL -> WAN"
            destination {
                address 0.0.0.0/24
            }
            outbound-interface eth0
            translation {
                address masquerade
            }
        }
    }
}
service {
    dhcp-server {
        hostfile-update
        host-decl-name
        shared-network-name LAN {
            authoritative
            ping-check
            subnet 192.168.0.0/24 {
                default-router 192.168.0.1
                lease 86400
                name-server 1.1.1.1
                range 0 {
                    start 192.168.0.100
                    stop 192.168.0.200
                }
            }
        }
        shared-network-name MGMT {
            authoritative
            ping-check
            subnet 192.168.10.0/24 {
                default-router 192.168.10.1
                lease 86400
                name-server 1.1.1.1
                range 0 {
                    start 192.168.10.100
                    stop 192.168.10.200
                }
            }
        }
        shared-network-name MGMT {
            authoritative
            ping-check
            subnet 192.168.10.0/24 {
                default-router 192.168.10.1
                lease 86400
                name-server 1.1.1.1
                range 0 {
                    start 192.168.10.100
                    stop 192.168.10.200
                }
                static-mapping tplink-ap-bonus {
                  ip-address 192.168.10.2
                  mac-address 1C:61:B4:CD:52:54
                }
                static-mapping tplink-ap-upstairs {
                  ip-address 192.168.10.3
                  mac-address 1C:61:B4:7D:30:EA
                }
                static-mapping tplink-ap-downstairs {
                  ip-address 192.168.10.4
                  mac-address B4:B0:24:9D:86:2E
                }
                subnet-parameters "option omada-address 192.168.10.20"
            }
        }
    }
    ntp {
        allow-client {
            address 127.0.0.0/8
            address 10.0.0.0/8
            address 172.16.0.0/12
            address 192.168.0.0/16
        }
        server time.cloudflare.com {
        }
    }
    ssh {
        disable-password-authentication
        port 22
    }
}
system {
    config-management {
        commit-revisions 100
    }
    conntrack {
        modules {
            ftp
            h323
            nfs
            pptp
            sip
            sqlnet
            tftp
        }
    }
    console {
        device ttyS0 {
            speed 115200
        }
    }
    domain-name "${SECRET_DOMAIN}"
    host-name gateway
    ipv6 {
        disable-forwarding
    }
    login {
        user vyos {
            authentication {
                encrypted-password
                plaintext-password ""
                public-keys stephen {
                    key AAAAC3NzaC1lZDI1NTE5AAAAIGld29CUwqAQkJICFRYRNu+olt05Xz7HIbcupAcisRC3
                    type ssh-ed25519
                }
            }
        }
    }
    name-server 1.1.1.1
    sysctl {
        parameter kernel.pty.max {
            value 24000
        }
    }
    syslog {
        global {
            facility all {
                level info
            }
            facility local7 {
                level debug
            }
        }
    }
    time-zone "${TIMEZONE}"
}
