# Minecraft for digitalocean via vagrant

There are many ways to create a minecraft server: this is mine.

Creates a minecraft server (on debian stable) including an
[overviewer](http://overviewer.org) map updated daily. It should be tuned
sufficiently to handle 5 to 10 concurrent users on a 1GB digitalocean image.

## Getting started

* Install vagrant
* Install the [vagrant-digitalocean](https://github.com/smdahlen/vagrant-digitalocean) plugin
* Create a digitalocean account and API token
* `git clone http://github.com/djcp/vdm.git vdm && cd vdm`
* Set up a file named `.env` based on `.env.example` including your values, most importantly your API token
* `source .env && vagrant up --provider=digital_ocean` # Time passes
* `vagrant ssh` # You're root!
* `sudo -u minecraft -i` # Launch a shell as the minecraft user
* Edit `~/minecraft/eula.txt` to accept the eula.
* Configure `~/minecraft/server.properties`
* Reboot via `vagrant halt && source .env && vagrant up --provider=digital_ocean`, or you can just reboot the minecraft server on your own.

## Notes

We set up two cron jobs under the "minecraft" user - one to start the minecraft
server in a shared screen settion at boot and another to update the overviewer
map daily.

You can access the cron-started minecraft server in a shared session as root (say, after `vagrant ssh`), via:

    screen -x minecraft/minecraft

You can manually start the minecraft server in a shared screen session via:

    sudo -u minecraft screen -dmS minecraft ~/bin/start_minecraft.sh

## Contributors

* [djcp](http://github.com/djcp)
