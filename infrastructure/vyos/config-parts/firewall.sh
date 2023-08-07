#!/bin/vbash

#General configuration
set firewall state-policy established action 'accept'
set firewall state-policy related action 'accept'
set firewall all-ping enable
set firewall broadcast-ping disable

#Address Groups
set firewall group address-group k8s_nodes address '192.168.20.5'
set firewall group address-group k8s_nodes address '192.168.20.6'
set firewall group address-group k8s_nodes address '192.168.20.7'
set firewall group address-group k8s_nodes address '192.168.20.8'
set firewall group address-group k8s_nodes address '192.168.20.9'
set firewall group address-group k8s_nodes address '192.168.20.10'

set firewall group address-group k8s_api address '192.168.5.2'

set firewall group address-group k8s_ingress address '192.168.21.10'

set firewall group address-group k8s_services network '10.43.0.0/16'
set firewall group address-group k8s_cluster network '10.42.0.0/16'

set firewall group address-group tplink_devices address '192.168.10.2'
set firewall group address-group tplink_devices address '192.168.10.3'
set firewall group address-group tplink_devices address '192.168.10.4'

set firewall group address-group printers address '192.168.50.20'

set firewall group address-group ios_devices address '192.168.50.2'
set firewall group address-group ios_devices address '192.168.50.3'
set firewall group address-group ios_devices address '192.168.50.4'
set firewall group address-group ios_devices address '192.168.50.5'
set firewall group address-group ios_devices address '192.168.50.6'
set firewall group address-group ios_devices address '192.168.50.7'
set firewall group address-group ios_devices address '192.168.50.8'
set firewall group address-group ios_devices address '192.168.50.9'
set firewall group address-group ios_devices address '192.168.50.10'

set firewall group address-group nas address '192.168.20.14'

# Port groups
set firewall group port-group wireguard port '51820'

set firewall group port-group Allowed_OUT_Ports_LAN port 53 # DNS
set firewall group port-group Allowed_OUT_Ports_LAN port
