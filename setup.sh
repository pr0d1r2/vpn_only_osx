#!/bin/bash

D_R=`cd \`dirname $0\` ; pwd -P`

OPENVPN_SERVER_IP=$1
OSX_VERSION=`sw_vers -productVersion`
OSX_VERSION_MINOR=`echo $OSX_VERSION | cut -f1-2 -d .`

case $OPENVPN_SERVER_IP in
  "")
    echo "Please give OpenVPN server IP address [for example: 64.64.64.64]:"
    read OPENVPN_SERVER_IP
    ;;
esac

function install_file() {
  sudo cp -rvp $1 $2
  sudo chown root:wheel $2
  sudo chmod $3 $2
}

install_file $D_R/pf.conf /etc/pf.conf.vpn_only_osx 600
case $OSX_VERSION_MINOR in
  10.10)
    sudo sed -ie "s/on tun0 from/on utun0 from/g" /etc/pf.conf.vpn_only_osx
    ;;
esac
sudo sed -ie "s/OPENVPN_SERVER_IP/$OPENVPN_SERVER_IP/g" /etc/pf.conf.vpn_only_osx

install_file $D_R/vpn_only_osx.sh /sbin/pf_vpn_only 700

install_file $D_R/pf_reset.sh /sbin/pf_reset 700

PLIST="/Library/LaunchDaemons/pl.prodix.vpn_only_osx.plist"
install_file $D_R/vpn_only_osx.plist $PLIST 700
sudo launchctl unload $PLIST
sudo launchctl load $PLIST
