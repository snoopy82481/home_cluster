#!/bin/vbash

set system domain-name 'idahobealefamily.com'
set system host-name 'gateway'

set system ipv6 disable-forwarding

set system login user vyos authentication public-keys personal key ''
set system login user vyos authenticatoin public-keys personal type ''

set system name-server '1.1.1.1'

set system sysctl parameter kernal.pty.max value '24000'

set system time-zone "${TIMEZONE}"
