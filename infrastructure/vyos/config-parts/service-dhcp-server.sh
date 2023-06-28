#!/bin/vbash

#LAN
set service dhcp-server shared-network-name LAN authoritative
set service dhcp-server shared-network-name LAN ping-check
set service dhcp-server shared-network-name LAN subnet 192.168.0.0/24 default-router '192.168.0.1'
set service dhcp-server shared-network-name LAN subnet 192.168.0.0/24 lease '86400'
set service dhcp-server shared-network-name LAN subnet 192.168.0.0/24 name-server ''
set service dhcp-server shared-network-name LAN subnet 192.168.0.0/24 range 0 start '192.168.0.100'
set service dhcp-server shared-network-name LAN subnet 192.168.0.0/24 range 0 stop '192.168.0.200'

#MGMT VLAN
set service dhcp-server shared-network-name MGMT authoritative
set service dhcp-server shared-network-name MGMT ping-check
set service dhcp-server shared-network-name MGMT subnet 192.168.10.0/24 default-router '192.168.10.1'
set service dhcp-server shared-network-name MGMT subnet 192.168.10.0/24 lease '86200'
set service dhcp-server shared-network-name MGMT subnet 192.168.10.0/24 name-server ''
set service dhcp-server shared-network-name MGMT subnet 192.168.10.0/24 range 0 start '192.168.10.100'
set service dhcp-server shared-network-name MGMT subnet 192.168.10.0/24 range 0 stop '192.168.10.200'
set service dhcp-server shared-network-name MGMT subnet 192.168.10.0/24 subnet-parameters 'option omada-address 192.168.10.20;'

set service dhcp-server shared-network-name MGMT subnet 192.168.10.0/24 static-mapping dell-idrac ip-address '192.168.10.5'
set service dhcp-server shared-network-name MGMT subnet 192.168.10.0/24 static-mapping dell-idrac mac-address ''
set service dhcp-server shared-network-name MGMT subnet 192.168.10.0/24 static-mapping cisco-switch ip-address '192.168.10.254'
set service dhcp-server shared-network-name MGMT subnet 192.168.10.0/24 static-mapping cisco-switch mac-address ''
set service dhcp-server shared-network-name MGMT subnet 192.168.10.0/24 static-mapping tplink-ap-bonus ip-address '192.168.10.2'
set service dhcp-server shared-network-name MGMT subnet 192.168.10.0/24 static-mapping tplink-ap-bonus mac-address '1C:61:B4:CD:52:54'
set service dhcp-server shared-network-name MGMT subnet 192.168.10.0/24 static-mapping tplink-ap-upstairs ip-address '192.168.10.3'
set service dhcp-server shared-network-name MGMT subnet 192.168.10.0/24 static-mapping tplink-ap-upstairs mac-address '1C:61:B4:7D:30:EA'
set service dhcp-server shared-network-name MGMT subnet 192.168.10.0/24 static-mapping tplink-ap-downstairs ip-address '192.168.10.4'
set service dhcp-server shared-network-name MGMT subnet 192.168.10.0/24 static-mapping tplink-ap-downstairs mac-address 'B4:B0:24:9D:86:2E'

#Server VLAN
set service dhcp-server shared-network-name SERVERS authoritative
set service dhcp-server shared-network-name SERVERS ping-check
set service dhcp-server shared-network-name SERVERS subnet 192.168.20.0/24 default-router '192.168.20.1'
set service dhcp-server shared-network-name SERVERS subnet 192.168.20.0/24 domain-name 'idahobealefamily.com'
set service dhcp-server shared-network-name SERVERS subnet 192.168.20.0/24 lease '86400'
set service dhcp-server shared-network-name SERVERS subnet 192.168.20.0/24 name-server ''
set service dhcp-server shared-network-name SERVERS subnet 192.168.20.0/24 range 0 start '192.168.20.100'
set service dhcp-server shared-network-name SERVERS subnet 192.168.20.0/24 range 0 stop '192.168.20.200'

set service dhcp-server shared-network-name SERVERS subnet 192.168.20.0/24 static-mapping kmaster1 ip-address '192.168.20.5'
set service dhcp-server shared-network-name SERVERS subnet 192.168.20.0/24 static-mapping kmaster1 mac-address ''
set service dhcp-server shared-network-name SERVERS subnet 192.168.20.0/24 static-mapping kmaster2 ip-address '192.168.20.6'
set service dhcp-server shared-network-name SERVERS subnet 192.168.20.0/24 static-mapping kmaster2 mac-address ''
set service dhcp-server shared-network-name SERVERS subnet 192.168.20.0/24 static-mapping kmaster3 ip-address '192.168.20.7'
set service dhcp-server shared-network-name SERVERS subnet 192.168.20.0/24 static-mapping kmaster3 mac-address ''
set service dhcp-server shared-network-name SERVERS subnet 192.168.20.0/24 static-mapping kworker1 ip-address '192.168.20.8'
set service dhcp-server shared-network-name SERVERS subnet 192.168.20.0/24 static-mapping kworker1 mac-address ''
set service dhcp-server shared-network-name SERVERS subnet 192.168.20.0/24 static-mapping kworker2 ip-address '192.168.20.9'
set service dhcp-server shared-network-name SERVERS subnet 192.168.20.0/24 static-mapping kworker2 mac-address ''
set service dhcp-server shared-network-name SERVERS subnet 192.168.20.0/24 static-mapping kworker3 ip-address '192.168.20.10'
set service dhcp-server shared-network-name SERVERS subnet 192.168.20.0/24 static-mapping kworker3 mac-address ''

#IoT VLAN
set service dhcp-server shared-network-name IOT authoritative
set service dhcp-server shared-network-name IOT ping-check
set service dhcp-server shared-network-name IOT subnet 192.168.30.0/24 default-router '192.168.40.1'
set service dhcp-server shared-network-name IOT subnet 192.168.30.0/24 domain-name 'idahobealefamily.com'
set service dhcp-server shared-network-name IOT subnet 192.168.30.0/24 lease '86400'
set service dhcp-server shared-network-name IOT subnet 192.168.30.0/24 name-server ''
set service dhcp-server shared-network-name IOT subnet 192.168.30.0/24 range 0 start '192.168.30.100'
set service dhcp-server shared-network-name IOT subnet 192.168.30.0/24 range 0 stop '192.168.30.200'

set service dhcp-server shared-network-name IOT subnet 192.168.30.0/24 static-mapping ecobee-upstairs ip-address '192.168.30.2'
set service dhcp-server shared-network-name IOT subnet 192.168.30.0/24 static-mapping ecobee-upstairs mac-address '44:61:32:50:C3:EA'
set service dhcp-server shared-network-name IOT subnet 192.168.30.0/24 static-mapping ecobee-main-floor ip-address '192.168.30.3'
set service dhcp-server shared-network-name IOT subnet 192.168.30.0/24 static-mapping ecobee-main-floor mac-address '44:61:32:C9:A4:1C'
set service dhcp-server shared-network-name IOT subnet 192.168.30.0/24 static-mapping samsung-dryer ip-address '192.168.30.4'
set service dhcp-server shared-network-name IOT subnet 192.168.30.0/24 static-mapping samsung-dryer mac-address '28:6D:97:FB:74:F9'
set service dhcp-server shared-network-name IOT subnet 192.168.30.0/24 static-mapping samsung-washer ip-address '192.168.30.5'
set service dhcp-server shared-network-name IOT subnet 192.168.30.0/24 static-mapping samsung-washer mac-address ''

#Guest VLAN
set service dhcp-server shared-network-name GUEST authoritative
set service dhcp-server shared-network-name GUEST ping-check
set service dhcp-server shared-network-name GUEST subnet 192.168.40.0/24 default-router '192.168.40.1'
set service dhcp-server shared-network-name GUEST subnet 192.168.40.0/24 lease '86400'
set service dhcp-server shared-network-name GUEST subnet 192.168.40.0/24 name-server ''
set service dhcp-server shared-network-name GUEST subnet 192.168.40.0/24 range 0 start '192.168.40.100'
set service dhcp-server shared-network-name GUEST subnet 192.168.40.0/24 range 0 stop '192.168.40.200'

#Trusted VLAN
set service dhcp-server shared-network-name TRUSTED authoritative
set service dhcp-server shared-network-name TRUSTED ping-check
set service dhcp-server shared-network-name TRUSTED subnet 192.168.50.0/24 default-router '192.168.50.1'
set service dhcp-server shared-network-name TRUSTED subnet 192.168.50.0/24 lease '86400'
set service dhcp-server shared-network-name TRUSTED subnet 192.168.50.0/24 name-server ''
set service dhcp-server shared-network-name TRUSTED subnet 192.168.50.0/24 range 0 start '192.168.50.100'
set service dhcp-server shared-network-name TRUSTED subnet 192.168.50.0/24 range 0 stop '192.168.50.200'

set service dhcp-server shared-network-name TRUSTED subnet 192.168.50.0/24 static-mapping stephen ip-address '192.168.50.2'
set service dhcp-server shared-network-name TRUSTED subnet 192.168.50.0/24 static-mapping stephen mac-address 'E0:D5:5E:AB:75:55'
set service dhcp-server shared-network-name TRUSTED subnet 192.168.50.0/24 static-mapping kidsfun ip-address '192.168.50.3'
set service dhcp-server shared-network-name TRUSTED subnet 192.168.50.0/24 static-mapping kidsfun mac-address ''
set service dhcp-server shared-network-name TRUSTED subnet 192.168.50.0/24 static-mapping stephen-iphone ip-address '192.168.50.4'
set service dhcp-server shared-network-name TRUSTED subnet 192.168.50.0/24 static-mapping stephen-iphone mac-address '7C:EC:B1:AF:F5:BC'
set service dhcp-server shared-network-name TRUSTED subnet 192.168.50.0/24 static-mapping becky-iphone ip-address '192.168.50.5'
set service dhcp-server shared-network-name TRUSTED subnet 192.168.50.0/24 static-mapping becky-iphone mac-address ''
set service dhcp-server shared-network-name TRUSTED subnet 192.168.50.0/24 static-mapping chris-iphone ip-address '192.168.50.6'
set service dhcp-server shared-network-name TRUSTED subnet 192.168.50.0/24 static-mapping chris-iphone mac-address ''
set service dhcp-server shared-network-name TRUSTED subnet 192.168.50.0/24 static-mapping chris-ipad ip-address '192.168.50.7'
set service dhcp-server shared-network-name TRUSTED subnet 192.168.50.0/24 static-mapping chris-ipad mac-address ''
set service dhcp-server shared-network-name TRUSTED subnet 192.168.50.0/24 static-mapping alex-iphone ip-address '192.168.50.8'
set service dhcp-server shared-network-name TRUSTED subnet 192.168.50.0/24 static-mapping alex-iphone mac-address ''
set service dhcp-server shared-network-name TRUSTED subnet 192.168.50.0/24 static-mapping alex-ipad ip-address '192.168.50.9'
set service dhcp-server shared-network-name TRUSTED subnet 192.168.50.0/24 static-mapping alex-ipad mac-address ''
set service dhcp-server shared-network-name TRUSTED subnet 192.168.50.0/24 static-mapping stephen-work-iphone ip-address '192.168.50.10'
set service dhcp-server shared-network-name TRUSTED subnet 192.168.50.0/24 static-mapping stephen-work-iphone mac-address ''
set service dhcp-server shared-network-name TRUSTED subnet 192.168.50.0/24 static-mapping sherley-android ip-address '192.168.50.11'
set service dhcp-server shared-network-name TRUSTED subnet 192.168.50.0/24 static-mapping sherley-android mac-address 'A0:4F:85:F6:43:99'
