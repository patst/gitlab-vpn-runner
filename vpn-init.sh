#!/bin/sh

echo "Creating tun device"
mkdir -p /dev/net
mknod /dev/net/tun c 10 200
chmod 600 /dev/net/tun

echo "Trying to start openVPN connection"

openvpn --config $VPN_CONFIG --auth-user-pass $AUTH_FILE --daemon vpn_daemon --writepid /var/run/openvpn-tun --log /var/log/openvpn/tun.log

echo "Waiting for VPN connection to be up. Curling $GITLAB_URL"

until $(curl --output /dev/null --silent --head --max-time 10 --fail $GITLAB_URL); do
    printf '.'
    sleep 5
done

echo VPN connection established.
