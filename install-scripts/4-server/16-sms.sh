#!/bin/bash -e

if [ "$BBN_KIND" == "LITE" ] ; then
  exit 0
fi

apt-get -y -q install ppp usb-modeswitch usb-modeswitch-data gammu

apt-get clean
