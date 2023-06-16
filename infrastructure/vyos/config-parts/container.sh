#!/bin/vbash

# Container networks
set container network containers description 'Network for VyOS containers'
set container network containers prefix '192.168.5.0/24'

# cloudflare-ddns
set container name cloudflare-ddns allow-host-networks
set container name cloudflare-ddns environment CF_API_TOKEN value "${SECRET_CLOUDFLARE_DYNDNS_TOKEN}"
set container name cloudflare-ddns environment DOMAINS value "ipv4.${SECRET_DOMAIN}"
set container name cloudflare-ddns environment IP6_PROVIDER value "none"
set container name cloudflare-ddns environment TZ value "${TIMEZONE}"
set container name cloudflare-ddns environment PGID value "1000"
set container name cloudflare-ddns environment PUID value "1000"
set container name cloudflare-ddns image 'docker.io/favonia/cloudflare-ddns:1.9.4'
set container name cloudflare-ddns memory '0'
set container name cloudflare-ddns restart 'on-failure'
set container name cloudflare-ddns shared-memory '0'

# haproxy-k8s-api
set container name haproxy-k8s-api image 'docker.io/library/haproxy:2.8.0'
set container name haproxy-k8s-api memory '0'
set container name haproxy-k8s-api network containers address '192.168.5.2'
set container name haproxy-k8s-api restart 'on-failure'
set container name haproxy-k8s-api shared-memory '0'
set container name haproxy-k8s-api volume config source '/config/containers/haproxy/config/haproxy.cfg'
set container name haproxy-k8s-api volume config destination '/usr/local/etc/haproxy/haproxy.cfg'
set container name haproxy-k8s-api volume config mode 'ro'

#omada-controller
set container name omada-controller description 'TPLink Omada Controller'
set container name omada-controller image 'docker.io/mbentley/omada-controller:5.9'
set container name omada-controller restart 'on-failure'
set container name haproxy-k8s-api memory '0'
set container name omada-controller environment TZ value "${TIMEZONE}"
set container name omada-controller environment MANAGE_HTTP_PORT value '8088'
set container name omada-controller environment MANAGE_HTTPS_PORT value '8043'
set container name omada-controller environment PORTAL_HTTP_PORT value '8088'
set container name omada-controller environment PORTAL_HTTPS_PORT value '8843'
set container name omada-controller environment SHOW_SERVER_LOGS value 'true'
set container name omada-controller environment SHOW_MONGODB_LOGS value 'true'
set container name omada-controller environment PGID value "1000"
set container name omada-controller environment PUID value "1000"
set container name omada-controller volume data source '/temp/omada/data'
set container name omada-controller volume data destination '/opt/tplink/EAPController/data'
set container name omada-controller volume data mode 'rw'
set container name omada-controller volume logs source '/temp/omada/data'
set container name omada-controller volume logs destination '/opt/tplink/EAPController/logs'
set container name omada-controller volume logs mode 'rw'
