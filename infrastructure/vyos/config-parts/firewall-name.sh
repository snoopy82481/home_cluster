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

# ---------------------------------

# From LOCAL to WAN
set firewall name local-wan description 'From LOCAL to WAN'
set firewall name local-wan default-action 'accept'

# From LOCAL to CONTAINERS
set firewall name local-containers description 'From LOCAL to CONTAINERS'
set firewall name local-containers default-action 'accept'
set firewall name local-containers rule 40 action 'accept'
set firewall name local-containers rule 40 description 'Rule: accept_dns'
set firewall name local-containers rule 40 destination port 'domain'
set firewall name local-containers rule 40 protocol 'tcp_udp'
set firewall name local-containers rule 999 description 'Rule: drop_invalid'
set firewall name local-containers rule 999 action 'drop'
set firewall name local-containers rule 999 state invalid 'enable'
set fierwall name local-containers rule 999 log 'enable'

# From LOCAL to LAN
set firewall name local-lan default-action 'drop'
set firewall name local-lan description 'From LOCAL to LAN'
set firewall name local-lan enable-default-log
set firewall name local-lan rule 999 action 'drop'
set firewall name local-lan rule 999 description 'Rule: drop_invalid'
set firewall name local-lan rule 999 state invalid 'enable'
set firewall name local-lan rule 999 log 'enable'

# From LOCAL to MGMT
set firewall name local-mgmt default-action 'drop'
set firewall name local-mgmt description 'From LOCAL to MGMT'
set firewall name local-mgmt enable-default-log
set firewall name local-mgmt rule 40 action 'accept'
set firewall name local-mgmt rule 40 description 'Rule: accept_dns'
set firewall name local-mgmt rule 40 destination port 'domain'
set firewall name local-mgmt rule 40 protocol 'tcp_udp'
set firewall name local-mgmt rule 999 action 'drop'
set firewall name local-mgmt rule 999 description 'Rule: drop_invalid'
set firewall name local-mgmt rule 999 state invalid 'enable'
set firewall name local-mgmt rule 999 log 'enable'

# From LOCAL to SERVERS
set firewall name local-servers default-action 'drop'
set firewall name local-servers description 'From LOCAL to SERVERS'
set firewall name local-servers enable-default-log
