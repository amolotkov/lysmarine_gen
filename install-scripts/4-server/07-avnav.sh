#!/bin/bash -e

apt-get clean

if [ "$BBN_KIND" == "LITE" ] ; then
  exit 0
fi

apt-get -q -y --no-install-recommends install avnav xterm mpg123 xvfb wx3.2-i18n python3-psutil

apt-get -q -y install avnav-history-plugin  avnav-more-nmea-plugin avnav-mapproxy-plugin # TODO: ???  avnav-raspi

#apt-get -q -y -o Dpkg::Options::="--force-overwrite" install avnav-oesenc

wget -O avnav-ocharts-plugin.deb https://www.free-x.de/debpreview/pool/main/a/avnav-ocharts-plugin/avnav-ocharts-plugin_20231216-raspbian-bookworm_arm64.deb
wget -O avnav-ocharts.deb https://www.free-x.de/debpreview/pool/main/a/avnav-ocharts/avnav-ocharts_1.0.44.0-1bookworm1_arm64.deb
dpkg -i avnav-ocharts-plugin.deb avnav-ocharts.deb
rm -f avnav-ocharts-plugin.deb avnav-ocharts.deb

wget -O avnav-sailinstrument-plugin.deb https://www.free-x.de/debpreview/pool/main/a/avnav-sailinstrument-plugin/avnav-sailinstrument-plugin_20230723_all.deb
dpkg -i avnav-sailinstrument-plugin.deb
rm -f avnav-sailinstrument-plugin.deb

install -o 0 -g 0 -d /usr/lib/systemd/system/avnav.service.d
install -o 0 -g 0 -m 0644 "$FILE_FOLDER"/lys-avnav.conf /usr/lib/systemd/system/avnav.service.d/
install -o 0 -g 0 -d /usr/lib/avnav/lysmarine
install -o 0 -g 0 -m 0644 "$FILE_FOLDER"/avnav_server_lysmarine.xml "/usr/lib/avnav/lysmarine/"

install -m 755 "$FILE_FOLDER"/avnav-restart "/usr/local/sbin/avnav-restart"

apt-get clean
npm cache clean --force

echo "" >>/etc/sudoers
echo 'user ALL=(ALL) NOPASSWD: /usr/local/sbin/avnav-restart' >>/etc/sudoers

usermod -a -G lirc avnav

systemctl enable avnav
