#!/bin/bash -e
rm -rf  /tmp/empty-cache46
rm -rvf /home/user/Public /home/user/Templates 

apt-get clean

apt-get remove -y --purge greybird-gtk-theme murrine-themes rpd-icons userconf-pi

apt-get -y autoremove
apt-get clean
npm cache clean --force || true
rm -rf ~/.local/share/pnpm

# remove python pip cache
rm -rf ~/.cache/pip

# remove all cache
rm -rf ~/.cache
rm -rf ~/.config
rm -rf ~/.npm
rm -rf ~/.wget*
rm -rf $(find /var/log/ -type f)
rm -f /opt/vc/src/hello_pi/hello_video/test.h264

# speed up boot without ethernet plugged
rm -rf /etc/systemd/system/dhcpcd.service.d/wait.conf
systemctl disable systemd-networkd-wait-online.service
#systemctl disable NetworkManager-wait-online.service
#systemctl mask plymouth-quit-wait.service
install -v -d "/etc/systemd/system/networking.service.d"
bash -c 'cat << EOF > /etc/systemd/system/networking.service.d/reduce-timeout.conf
[Service]
TimeoutStartSec=8
EOF'
install -v -d "/etc/systemd/system/nmbd.service.d"
bash -c 'cat << EOF > /etc/systemd/system/nmbd.service.d/reduce-timeout.conf
[Service]
TimeoutStartSec=15
RestartSec=60
Restart=always
EOF'

echo '/usr/lib /usr/share /usr/include /usr/bin /srv' | xargs -n 1 -P 4 hardlink -v -t

if [ "$BBN_KIND" == "LITE" ] ; then
  true
else
  apt-get -q -y install --download-only avnav-update-plugin
fi

for f in /etc/apt/sources.list.d/bbn-*.list
do
  mv "$f" "$f"-orig
done

# These are launchpad. They are ok to have.
mv /etc/apt/sources.list.d/bbn-rce.list-orig /etc/apt/sources.list.d/bbn-rce.list || true
mv /etc/apt/sources.list.d/bbn-kplex.list-orig /etc/apt/sources.list.d/bbn-kplex.list || true

rm -f /etc/apt/sources.list.d/*.list-orig

install -v -m 0644 "$FILE_FOLDER"/rsyslog "/etc/logrotate.d/rsyslog"

# clean up more
rm -rf /usr/share/doc/noaa-apt/docs/examples/argentina.wav*
rm -rf /usr/share/doc/nodejs/api/
rm -rf /usr/share/doc/nodejs/changelogs/
rm -rf /usr/share/doc/tcllib/html/
rm -rf /usr/share/doc/openjdk*/test*/*
rm -rf /usr/share/doc/python3*/HISTORY.*
rm -rf /usr/share/doc/python3*/NEWS.*
rm -rf /usr/share/backgrounds/budgie/*
rm -rf /var/lib/apt/lists/*
rm -f /2
find /usr/share/doc -name changelog\*.gz -exec rm -f {} \;
find /usr/share/doc -name NEWS\*.gz -exec rm -f {} \;

if [ "$BBN_KIND" == "LITE" ] ; then
  echo 1 > /etc/bbn-lite
fi

date --rfc-3339=seconds > /etc/bbn-build
fake-hwclock save

chown root:root /
chmod 755 /

rm -rf /boot/issue.txt
#install -v -m0644 "$FILE_FOLDER"/issue.txt "/boot/"
install -v -m0644 "$FILE_FOLDER"/firstrun.sh "/boot/"

rm -f /usr/share/applications/xgpsspeed.desktop
rm -f /usr/share/applications/xgps.desktop
rm -f /usr/share/applications/yad-icon-browser.desktop

sed -i 's/#RebootWatchdogSec=10min/RebootWatchdogSec=75s/' /etc/systemd/system.conf

# Fill free space with zeros
cat /dev/zero > /zer0s || true
rm -f /zer0s
