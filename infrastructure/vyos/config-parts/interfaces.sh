#!/bin/vbash

set interfaces ethernet eth0 description 'WAN'
set interfaces ethernet eth0 hw-id ''
set interfaces ethernet eth0 address 'dhcp'

set interfaces ethernet eth0 description 'LAN'
set interfaces ethernet eth1 address '192.168.0.1/24'
set interfaces ethernet eth1 hw-id ''
set interfaces ethernet eth1 vif 10 description 'MGMT'
set interfaces ethernet eth1 vif 10 address '192.168.10.1/24'
set interfaces ethernet eth1 vif 20 description 'SERVER'
set interfaces ethernet eth1 vif 20 address '192.168.20.1/24'
set interfaces ethernet eth1 vif 30 description 'IOT'
set interfaces ethernet eth1 vif 30 address '192.168.30.1/24'
set interfaces ethernet eth1 vif 40 description 'GUEST'
set interfaces ethernet eth1 vif 40 address '192.168.40.1/24'
