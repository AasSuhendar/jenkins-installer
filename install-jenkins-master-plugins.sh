#!/bin/bash -e
MY_PATH=$(pwd)

echo "--------------------------------------------------"
echo "Jenkins Plugins Installer for Debian/Ubuntu"
echo "Email: aas.suhendar@gmail.com
echo "--------------------------------------------------"


echo ""
echo "[1] Installing Jenkins Plugins"
echo "--------------------------------------------------"
cd $MY_PATH \
  && cp $MY_PATH/etc/plugins.txt /var/lib/jenkins/plugins.txt \
  && cp $MY_PATH/etc/plugins.txt /var/lib/jenkins/plugins.txt.lock \
  && rm -rf /usr/share/jenkins/ref/plugins/*.lock \
  && /usr/local/bin/install-plugins.sh $(cat /var/lib/jenkins/plugins.txt| tr '\n' ' ')
echo "--------------------------------------------------"


echo ""
echo "[2] Restarting System"
echo "--------------------------------------------------"
reboot
echo "--------------------------------------------------"


exit 0
