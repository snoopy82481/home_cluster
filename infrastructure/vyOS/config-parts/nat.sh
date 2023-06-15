#!/bin/vbash

# Force NTP
set nat destination rule 104 description 'Force NTP for LAN'
set nat destination rule 104 destination address '!192.168.0.1'
set nat destination rule 104 destination port '123'
set nat destination rule 104 inbound-interface 'eth1'
set nat destination rule 104 protocol 'udp'
set nat destination rule 104 translation address '192.168.0.1'
set nat destination rule 104 translation port '123'

set nat destination rule 106 description 'Force NTP for MGMT'
set nat destination rule 106 destination address '!192.168.10.1'
set nat destination rule 106 destination port '123'
set nat destination rule 106 inbound-interface 'eth1.10'
set nat destination rule 106 protocol 'udp'
set nat destination rule 106 translation address '192.168.10.1'
set nat destination rule 106 translation port '123'

set nat destination rule 105 description 'Force NTP for Servers'
set nat destination rule 105 destination address '192.168.20.1'
set nat destination rule 105 destination port '123'
set nat destination rule 105 inbound-interface 'eth1.20'
set nat destination rule 105 protocol 'udp'
set nat destination rule 105 translation address '192.168.20.1'
set nat destination rule 105 translation port '123'

set nat destination rule 107 description 'Force NTP for IOT'
set nat destination rule 107 destination address '!192.168.30.1'
set nat destination rule 107 destination port '123'
set nat destination rule 107 inbound-interface 'eth1.30'
set nat destination rule 107 protocol 'udp'
set nat destination rule 107 translation address '192.168.30.1'
set nat destination rule 107 translation port '123'

set nat destination rule 108 description 'Force NTP for GUEST'
set nat destination rule 108 destination address '!192.168.40.1'
set nat destination rule 108 destination port '123'
set nat destination rule 108 inbound-interface 'eth1.40'
set nat destination rule 108 protocol 'udp'
set nat destination rule 108 translation address '192.168.40.1'
set nat destination rule 108 translation port '123'

# LAN -> WAN masquerade
set nat source rule 100 description 'LAN -> WAN'
set nat source rule 100 destination address '0.0.0.0/0'
set nat source rule 100 outbound-interface 'eth1'
set nat source rule 100 translation address 'masquerade'
