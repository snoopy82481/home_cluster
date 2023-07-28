#!/bin/vbash

# From WAN to LOCAL
set firewall name wan-local default-action 'drop'
set firewall name wan-local description 'From WAN to LOCAL'
set firewall name wan-local enabled-default-log
set firewall name wan-local rule 100 description 'Rule: accept_wireguard'
set firewall name wan-local rule 100 action 'accept'
set firewall name wan-local rule 100 destination port '51820'
set fierwall name wan-local rule 100 protocol 'udp'
set firewall name wan-local rule 999 description 'Rule: drop_invalid'
set firewall name wan-local rule 999 action 'drop'
set firewall name wan-local rule 999 state invalid 'enable'
set fierwall name wan-local rule 999 log 'enable'

# From WAN to CONTAINERS
set firewall name wan-containers default-action 'drop'
set firewall name wan-containers description 'From WAN to CONTAINERS'
set firewall name wan-containers enabled-default-log
set firewall name wan-containers rule 999 description 'Rule: drop_invalid'
set firewall name wan-containers rule 999 action 'drop'
set firewall name wan-containers rule 999 state invalid 'enable'
set fierwall name wan-containers rule 999 log 'enable'

# From WAN to LAN
set firewall name wan-lan default-action 'drop'
set firewall name wan-lan description 'From WAN to LAN'
set firewall name wan-lan enabled-default-log
set firewall name wan-lan rule 999 description 'Rule: drop_invalid'
set firewall name wan-lan rule 999 action 'drop'
set firewall name wan-lan rule 999 state invalid 'enable'
set fierwall name wan-lan rule 999 log 'enable'

# From WAN to GUEST
set firewall name wan-guest default-action 'drop'
set firewall name wan-guest description 'From WAN to GUEST'
set firewall name wan-guest enabled-default-log
set firewall name wan-guest rule 999 description 'Rule: drop_invalid'
set firewall name wan-guest rule 999 action 'drop'
set firewall name wan-guest rule 999 state invalid 'enable'
set fierwall name wan-guest rule 999 log 'enable'

# From WAN to MGMT
set firewall name wan-mgmt default-action 'drop'
set firewall name wan-mgmt description 'From WAN to MGMT'
set firewall name wan-mgmt enabled-default-log
set firewall name wan-mgmt rule 999 description 'Rule: drop_invalid'
set firewall name wan-mgmt rule 999 action 'drop'
set firewall name wan-mgmt rule 999 state invalid 'enable'
set fierwall name wan-mgmt rule 999 log 'enable'

# From WAN to SERVERS
set firewall name wan-servers default-action 'drop'
set firewall name wan-servers description 'From WAN to SERVERS'
set firewall name wan-servers enabled-default-log
set firewall name wan-servers rule 999 description 'Rule: drop_invalid'
set firewall name wan-servers rule 999 action 'drop'
set firewall name wan-servers rule 999 state invalid 'enable'
set fierwall name wan-servers rule 999 log 'enable'

# From WAN to IOT
set firewall name wan-iot default-action 'drop'
set firewall name wan-iot description 'From WAN to IOT'
set firewall name wan-iot enabled-default-log
set firewall name wan-iot rule 999 description 'Rule: drop_invalid'
set firewall name wan-iot rule 999 action 'drop'
set firewall name wan-iot rule 999 state invalid 'enable'
set fierwall name wan-iot rule 999 log 'enable'

# From WAN to TRUSTED
set firewall name wan-trusted default-action 'drop'
set firewall name wan-trusted description 'From WAN to TRUSTED'
set firewall name wan-trusted enabled-default-log
set firewall name wan-trusted rule 999 description 'Rule: drop_invalid'
set firewall name wan-trusted rule 999 action 'drop'
set firewall name wan-trusted rule 999 state invalid 'enable'
set fierwall name wan-trusted rule 999 log 'enable'
