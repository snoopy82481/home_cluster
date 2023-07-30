#!/bin/vbash

set firewall zone local default-action 'drop'
set firewall zone local description 'Local router zone'
set firewall zone local from iot firewall name 'iot-local'
set firewall zone local from servers firewall name 'servers-local'
set firewall zone local from containers firewall name 'containers-local'
set firewall zone local from trusted firewall name 'trusted-local'
set firewall zone local from mgmt firewall name 'mgmt-local'
set firewall zone local from wan firewall name 'wan-local'
set firewall zone local local-zone

set firewall zone containers default-action 'drop'
set firewall zone containers description 'VyOS containers zone'
set firewall zone containers from guest firewall name 'guest-containers'
set firewall zone containers from iot firewall name 'iot-containers'
set firewall zone containers from lan firewall name 'lan-containers'
set firewall zone containers from local firewall name 'local-containers'
set firewall zone containers from servers firewall name 'servers-containers'
set firewall zone containers from trusted firewall name 'trusted-containers'
set firewall zone containers from mgmt firewall name 'mgmt-containers'
set firewall zone containers from wan firewall name 'wan-containers'
set firewall zone containers interface 'pod-containers'

set firewall zone wan default-action 'drop'
set firewall zone wan description 'VyOS WAN zone'
set firewall zone wan from iot firewall name 'iot-wan'
set firewall zone wan from lan firewall name 'lan-wan'
set firewall zone wan from local firewall name 'local-wan'
set firewall zone wan from servers firewall name 'servers-wan'
set firewall zone wan from containers firewall name 'containers-wan'
set firewall zone wan from trusted firewall name 'trusted-wan'
set firewall zone wan from mgmt firewall name 'mgmt-wan'
set firewall zone wan interface 'eth0'

set firewall zone lan default-action 'drop'
set firewall zone lan description 'VyOS LAN zone'
set firewall zone lan from iot firewall name 'iot-lan'
set firewall zone lan from local firewall name 'local-lan'
set firewall zone lan from servers firewall name 'servers-lan'
set firewall zone lan from containers firewall name 'containers-lan'
set firewall zone lan from trusted firewall name 'trusted-lan'
set firewall zone lan from mgmt firewall name 'mgmt-lan'
set firewall zone lan from wan firewall name 'wan-lan'
set firewall zone lan interface 'eth1'

set firewall zone mgmt default-action 'drop'
set firewall zone mgmt description 'VyOS MGMT zone'
set firewall zone mgmt from iot firewall name 'iot-mgmt'
set firewall zone mgmt from local firewall name 'local-mgmt'
set firewall zone mgmt from servers firewall name 'servers-mgmt'
set firewall zone mgmt from containers firewall name 'containers-mgmt'
set firewall zone mgmt from trusted firewall name 'trusted-mgmt'
set firewall zone mgmt from wan firewall name 'mgmt-wan'
set firewall zone mgmt interface 'eth1.10'

set firewall zone servers default-action 'drop'
set firewall zone servers description 'VyOS SERVERS zone'
set firewall zone servers from wan firewall name 'wan-servers'
set firewall zone servers from local firewall name 'local-servers'
set firewall zone servers from containers firewall name 'containers-servers'
set firewall zone servers from lan firewall name 'lan-servers'
set firewall zone servers from mgmt firewall name 'mgmt-servers'
set firewall zone servers from iot firewall name 'iot-servers'
set firewall zone servers from guest firewall name 'mgmt-guest'
set firewall zone servers from trusted firewall name 'mgmt-trusted'
set firewall zone mgmt interface 'eth1.20'

set firewall zone iot default-action 'drop'
set firewall zone iot description 'VyOS IOT zone'
set firewall zone iot from wan name 'iot-wan'
set firewall zone iot from local firewall name 'iot-local'
set firewall zone iot from containers firewall name 'iot-containers'
set firewall zone iot from lan name 'iot-lan'
set firewall zone iot from mgmt name 'iot-mgmt'
set firewall zone iot from servers name 'iot-servers'
set firewall zone iot from guest name 'iot-guest'
set firewall zone iot from trusted name 'iot-trusted'
set firewall zone iot interface 'eth1.30'

set firewall zone guest default-action 'drop'
set firewall zone guest description 'VyOS GUEST zone'
set firewall zone guest from wan name 'guest-wan'
set firewall zone guest from local firewall name 'guest-local'
set firewall zone guest from containers firewall name 'guest-containers'
set firewall zone guest from lan name 'guest-lan'
set firewall zone guest from mgmt name 'guest-mgmt'
set firewall zone guest from servers name 'guest-servers'
set firewall zone guest from iot name 'guest-iot'
set firewall zone guest from trusted name 'guest-trusted'
set firewall zone guest interface 'eth1.40'

set firewall zone trusted default-action 'drop'
set firewall zone trusted description 'VyOS TRUSTED zone'
set firewall zone trusted from wan name 'trusted-wan'
set firewall zone trusted from local firewall name 'trusted-local'
set firewall zone trusted from containers firewall name 'trusted-containers'
set firewall zone trusted from lan name 'trusted-lan'
set firewall zone trusted from mgmt name 'trusted-mgmt'
set firewall zone trusted from servers name 'trusted-servers'
set firewall zone trusted from iot name 'trusted-iot'
set firewall zone trusted from guest name 'trusted-guest'
set firewall zone trusted interface 'eth1.50'
set firewall zone trusted interface 'wg01'