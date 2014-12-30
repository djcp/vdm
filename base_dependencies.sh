#!/bin/bash

echo 'deb http://overviewer.org/debian ./' > /etc/apt/sources.list.d/minecraft_overviewer.list
wget -O - http://overviewer.org/debian/overviewer.gpg.asc | sudo apt-key add -

aptitude update && aptitude dist-upgrade -y
aptitude install -y vim-nox default-jdk screen htop python2.6 minecraft-overviewer htop nginx-light

if id minecraft &> /dev/null; then
  echo 'initializing minecraft user'
  adduser minecraft --system --group --shell /bin/bash
  sudo -u minecraft bash -c 'mkdir ~/minecraft/ && mkdir ~/bin/ && wget -O ~/minecraft/minecraft_server.jar https://s3.amazonaws.com/Minecraft.Download/versions/1.8.1/minecraft_server.1.8.1.jar'
  echo "multiuser on
  acladd root" > /home/minecraft/.screenrc
  sudo -u minecraft bash -c 'wget https://s3.amazonaws.com/Minecraft.Download/versions/1.8/1.8.jar -P ~/.minecraft/versions/1.8/'
else
  echo 'user already initialized'
fi

if ! grep swap /etc/fstab &> /dev/null ; then
  echo 'Making a small swap file'
  dd if=/dev/zero of=/swapfile1 bs=1024 count=524288
  chown root:root /swapfile1
  chmod 0600 /swapfile1
  mkswap /swapfile1
  swapon /swapfile1
  echo '/swapfile1 none swap sw 0 0' > /etc/fstab
fi

echo 'cd ~/minecraft && java -Xmx768M -jar minecraft_server.jar nogui' > /home/minecraft/bin/start_minecraft.sh
chmod 755 /home/minecraft/bin/start_minecraft.sh
chown -R minecraft.minecraft /home/minecraft/

if [ ! -e /etc/nginx/sites-available/overviewer.conf ]; then
  echo 'installing overviewer nginx config. This will not work correctly until overviewer runs,
by default the next time daily cron jobs run.'
  echo '
server {
  listen 80;
  root /home/minecraft/overviewer;
  index index.html;
}
' > /etc/nginx/sites-available/overviewer.conf
  ln -s /etc/nginx/sites-available/overviewer.conf /etc/nginx/sites-enabled/overviewer.conf
  /etc/init.d/nginx restart
fi

if (sudo -u minecraft crontab -l | grep screen) &> /dev/null ; then
  echo 'installing reboot minecraft server task in a shared screen session'
  echo 'installing overviewer daily re-render'
  echo '@reboot screen -dmS minecraft ~/bin/start_minecraft.sh
@daily /usr/bin/overviewer.py ~/minecraft/world/ ~/overviewer/
' | sudo -u minecraft crontab -
fi
