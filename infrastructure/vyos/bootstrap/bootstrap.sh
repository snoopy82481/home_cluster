#!/bin/bash

load /opt/vyatta/etc/config.boot.default

set interfaces ethernet eth0 description 'WAN'
set interfaces ethernet eth0 address 'dhcp'
set interfaces ethernet eth0 hw-id ''

set interfaces ethernet eth1 description 'LAN'
set interfaces ethernet eth1 address '192.168.0.1/24'
set interfaces ethernet eth1 hw-id ''
set interfaces ethernet eth1 vif 5 description 'SERVICE'
set interfaces ethernet eth1 vif 5 address '192.168.5.1/24'

set system login user vyos authentication public-keys stephen key "AAAAC3NzaC1lZDI1NTE5AAAAIGld29CUwqAQkJICFRYRNu+olt05Xz7HIbcupAcisRC3"
set system login user vyos authentication public-keys stephen type 'ssh-ed25519'

set service ssh disable-password-authentication
set service ssh port '22'

delete system host-name
set system host-name 'gateway'
set system domain-name "idahobealefamily.com"

set system ipv6 disable-forwarding

set system name-server '1.1.1.1'

set system sysctl parameter kernel.pty.max value '24000'

set system time-zone "America\Boise"

set service dhcp-server hostfile-update
set service dhcp-server host-decl-name

set service dhcp-server shared-network-name LAN authoritative
set service dhcp-server shared-network-name LAN ping-check
set service dhcp-server shared-network-name LAN subnet 192.168.0.0/24 default-router '192.168.0.1'
set service dhcp-server shared-network-name LAN subnet 192.168.0.0/24 lease '900'
set service dhcp-server shared-network-name LAN subnet 192.168.0.0/24 name-server '1.1.1.1'
set service dhcp-server shared-network-name LAN subnet 192.168.0.0/24 range 0 start '192.168.0.100'
set service dhcp-server shared-network-name LAN subnet 192.168.0.0/24 range 0 stop '192.168.0.200'

set service dhcp-server shared-network-name SERVICE authoritative
set service dhcp-server shared-network-name SERVICE ping-check
set service dhcp-server shared-network-name SERVICE subnet 192.168.5.0/24 default-router '192.168.5.1'
set service dhcp-server shared-network-name SERVICE subnet 192.168.5.0/24 lease '900'
set service dhcp-server shared-network-name SERVICE subnet 192.168.5.0/24 name-server '1.1.1.1'
set service dhcp-server shared-network-name SERVICE subnet 192.168.5.0/24 range 0 start '192.168.5.100'
set service dhcp-server shared-network-name SERVICE subnet 192.168.5.0/24 range 0 stop '192.168.5.200'

# ALL -> WAN masquerade
set nat source rule 100 description 'ALL -> WAN'
set nat source rule 100 outbound-interface 'eth0'
set nat source rule 100 destination address '0.0.0.0/0'
set nat source rule 100 translation address 'masquerade'

# General configuration
set firewall state-policy established action 'accept'
set firewall state-policy invalid action 'drop'
set firewall state-policy related action 'accept'

set firewall zone lan description 'LAN backbone'
set firewall zone lan default-action 'drop'
set firewall zone lan from local firewall name 'local-lan'
set firewall zone lan from services firewall name 'services-lan'
set firewall zone lan from wan firewall name 'wan-lan'
set firewall zone lan interface 'eth0'
set firewall zone lan interface 'eth1.5'

set firewall zone local description 'Local router zone'
set firewall zone local default-action 'drop'
set firewall zone local from lan firewall name 'lan-local'
set firewall zone local from services firewall name 'services-local'
set firewall zone local from wan firewall name 'wan-local'
set firewall zone local local-zone

set firewall zone services description 'VyOS services zone'
set firewall zone services default-action 'drop'
set firewall zone services from lan firewall name 'lan-services'
set firewall zone services from local firewall name 'local-services'
set firewall zone services from wan firewall name 'wan-services'
set firewall zone services interface 'cni-services'

set firewall zone wan description 'WAN'
set firewall zone wan default-action 'drop'
set firewall zone wan from lan firewall name 'lan-wan'
set firewall zone wan from local firewall name 'local-wan'
set firewall zone wan from services firewall name 'services-wan'
set firewall zone wan interface 'eth0'

# From LAN to LOCAL
set firewall name lan-local description 'From LAN to LOCAL'
set firewall name lan-local default-action 'accept'
set firewall name lan-local enable-default-log

# From LAN to SERVICES
set firewall name lan-services description 'From LAN to SERVICES'
set firewall name lan-services default-action 'accept'
set firewall name lan-services enable-default-log

# From LAN to WAN
set firewall name lan-wan description 'From LAN to WAN'
set firewall name lan-wan default-action 'accept'
set firewall name lan-wan enable-default-log

# From LOCAL to LAN
set firewall name local-lan description 'From LOCAL to LAN'
set firewall name local-lan default-action 'accept'
set firewall name local-lan enable-default-log

# From LOCAL to SERVICES
set firewall name local-services description 'From LOCAL to SERVICES'
set firewall name local-services default-action 'accept'
set firewall name local-services enable-default-log

# From LOCAL to WAN
set firewall name local-wan description 'From LOCAL to WAN'
set firewall name local-wan default-action 'accept'
set firewall name local-wan enable-default-log

# From SERVICES to LAN
set firewall name services-lan description 'From SERVICES to LAN'
set firewall name services-lan default-action 'accept'
set firewall name services-lan enable-default-log

# From SERVICES to LOCAL
set firewall name services-local description 'From SERVICES to LOCAL'
set firewall name services-local default-action 'accept'

# From SERVICES to WAN
set firewall name services-wan description 'From SERVICES to WAN'
set firewall name services-wan default-action 'accept'

# From WAN to LAN
set firewall name wan-lan description 'From WAN to LAN'
set firewall name wan-lan default-action 'drop'
set firewall name wan-lan enable-default-log

# From WAN to LOCAL
set firewall name wan-local description 'From WAN to LOCAL'
set firewall name wan-local default-action 'drop'
set firewall name wan-local enable-default-log

# From WAN to SERVICES
set firewall name wan-services description 'From WAN to SERVICES'
set firewall name wan-services default-action 'drop'
set firewall name wan-services enable-default-log
