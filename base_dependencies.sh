#!/bin/bash

main(){
  install_overviewer_apt_source
  install_base_dependencies
  if ! id minecraft &> /dev/null; then
    init_minecraft
  fi
  if ! grep swap /etc/fstab &> /dev/null ; then
    create_swap_file
  fi
  install_startup_task
  if [ ! -e /etc/nginx/sites-available/overviewer.conf ]; then
    configure_nginx_for_overviewer
  fi
  if ! (sudo -u minecraft crontab -l | grep screen) &> /dev/null ; then
    install_cron_jobs
  fi
}

install_overviewer_apt_source(){
  echo 'deb http://overviewer.org/debian ./' > /etc/apt/sources.list.d/minecraft_overviewer.list
  wget -q -O - http://overviewer.org/debian/overviewer.gpg.asc | sudo apt-key add -
}

install_base_dependencies(){
  aptitude update && aptitude dist-upgrade -y
  aptitude install -y vim-nox default-jdk screen htop python2.6 minecraft-overviewer htop nginx-light
}

init_minecraft(){
  echo 'initializing minecraft user'
  adduser minecraft --system --group --shell /bin/bash
  echo 'downloading minecraft_server.jar'
  sudo -u minecraft bash -c 'mkdir ~/minecraft/ && mkdir ~/bin/ && wget -q -O ~/minecraft/minecraft_server.jar https://s3.amazonaws.com/Minecraft.Download/versions/1.8.1/minecraft_server.1.8.1.jar'
  echo "multiuser on
  acladd root" > /home/minecraft/.screenrc
  echo 'downloading minecraft assets for overviewer'
  sudo -u minecraft bash -c 'wget -q https://s3.amazonaws.com/Minecraft.Download/versions/1.8/1.8.jar -P ~/.minecraft/versions/1.8/'
}

create_swap_file(){
  swap=$(echo "$(grep -i memtotal /proc/meminfo | sed 's/[^0-9]*//g') / 2" | bc)
  echo "Making a swap file of $swap kilobytes, half of your droplet's RAM"
  dd if=/dev/zero of=/swapfile1 bs=1024 count=$swap
  chown root:root /swapfile1
  chmod 0600 /swapfile1
  mkswap /swapfile1
  swapon /swapfile1
  echo '/swapfile1 none swap sw 0 0' > /etc/fstab
}

install_startup_task(){
  minecraft_ram=$(echo "(($(grep -i memtotal /proc/meminfo | sed 's/[^0-9]*//g')) - (100 * 1024)) / 1024" | bc)
  echo "setting max ram to (available RAM - 100 meg) = $minecraft_ram meg"
  echo "cd ~/minecraft && java -Xmx${minecraft_ram}M -jar minecraft_server.jar nogui" > /home/minecraft/bin/start_minecraft.sh
  chmod 755 /home/minecraft/bin/start_minecraft.sh
  chown -R minecraft.minecraft /home/minecraft/
}

configure_nginx_for_overviewer(){
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
}

install_cron_jobs(){
  echo 'installing reboot minecraft server task in a shared screen session'
  echo 'installing overviewer daily re-render'
  echo '@reboot screen -dmS minecraft ~/bin/start_minecraft.sh
@daily /usr/bin/overviewer.py ~/minecraft/world/ ~/overviewer/
' | sudo -u minecraft crontab -
}

main
