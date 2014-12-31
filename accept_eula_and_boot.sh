#!/bin/bash

echo "#By changing the setting below to TRUE you are indicating your agreement to our EULA (https://account.mojang.com/documents/minecraft_eula).
eula=true
" > /home/minecraft/minecraft/eula.txt
chown minecraft.minecraft /home/minecraft/minecraft/eula.txt

sudo -u minecraft -i bash -c 'screen -dmS minecraft ~/bin/start_minecraft.sh'
