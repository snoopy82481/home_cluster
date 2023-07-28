#!/bin/vbash

set interfaces ethernet eth0 description 'WAN'
set interfaces ethernet eth0 hw-id 'E8:EA:6A:03:17:0F'
set interfaces ethernet eth0 address 'dhcp'

set interfaces ethernet eth1 description 'LAN'
set interfaces ethernet eth1 address '192.168.0.1/24'
set interfaces ethernet eth1 hw-id 'E8:EA:6A:03:17:10'
set interfaces ethernet eth1 vif 10 description 'MGMT'
set interfaces ethernet eth1 vif 10 address '192.168.10.1/24'
set interfaces ethernet eth1 vif 20 description 'SERVERS'
set interfaces ethernet eth1 vif 20 address '192.168.20.1/24'
set interfaces ethernet eth1 vif 30 description 'IOT'
set interfaces ethernet eth1 vif 30 address '192.168.30.1/24'
set interfaces ethernet eth1 vif 40 description 'GUEST'
set interfaces ethernet eth1 vif 40 address '192.168.40.1/24'
set interfaces ethernet eth1 vif 50 description 'TRUSTED'
set interfaces ethernet eth1 vif 50 address '192.168.50.1/24'

set interfaces wireguard wg01 address '192.168.1.1/24'
set interfaces wireguard wg01 description 'WIREGUARD'
set interfaces wireguard wg01 port '51820'
set interfaces wireguard wg01 private-key "${SECRET_WIREGUARD_PRIVATE_KEY}"
