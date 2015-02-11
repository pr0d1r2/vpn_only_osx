#!/bin/bash

D_R=`cd \`dirname $0\` ; pwd -P`

PLIST="/Library/LaunchDaemons/pl.prodix.vpn_only_osx.plist"

if [ -f /sbin/pf_reset ]; then
  sudo /sbin/pf_reset
fi

if [ -f $PLIST ]; then
  sudo launchctl unload $PLIST
fi

sudo rm -f /etc/pf.conf.vpn_only_osx \
           /sbin/pf_vpn_only \
           /sbin/pf_reset \
           $PLIST
