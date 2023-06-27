#!/bin/vbash

#BGP configuration
set protocols bgp neighbor 192.168.20.5 address-family ipv4-unicast
set protocols bgp neighbor 192.168.20.5 description 'kmaster1'
set protocols bgp neighbor 192.168.20.5 remote-as '64500'
set protocols bgp neighbor 192.168.20.5 address-family ipv4-unicast
set protocols bgp neighbor 192.168.20.5 description 'kmaster2'
set protocols bgp neighbor 192.168.20.5 remote-as '64500'
set protocols bgp neighbor 192.168.20.5 address-family ipv4-unicast
set protocols bgp neighbor 192.168.20.5 description 'kmaster3'
set protocols bgp neighbor 192.168.20.5 remote-as '64500'
set protocols bgp neighbor 192.168.20.5 address-family ipv4-unicast
set protocols bgp neighbor 192.168.20.5 description 'kworker1'
set protocols bgp neighbor 192.168.20.5 remote-as '64500'
set protocols bgp neighbor 192.168.20.5 address-family ipv4-unicast
set protocols bgp neighbor 192.168.20.5 description 'kworker2'
set protocols bgp neighbor 192.168.20.5 remote-as '64500'
set protocols bgp neighbor 192.168.20.5 address-family ipv4-unicast
set protocols bgp neighbor 192.168.20.5 description 'kworker3'
set protocols bgp neighbor 192.168.20.5 remote-as '64501'
set protocols bgp system-as '64500'
