# Vagrant :: Digitalocean :: Minecraft

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
* `source .env && vagrant up --provider=digital_ocean` # Time passes.
* `source .env && vagrant ssh` # You're root!
* `sudo -u minecraft -i` # Launch a shell as the minecraft user, or
* `screen -x minecraft/minecraft` to access the running minecraft server

## Notes

You must set `EULA_ACCEPTED` to `true` in your .env to allow the setup to
complete and start a working minecraft server.

We set up two cron jobs under the "minecraft" user:

* One to start the minecraft server in a shared screen session at boot, and
* One to update the overviewer map daily.

After configuration and a reboot, you can access the cron-started minecraft
server in a shared session as root (say, after `vagrant ssh`), via:

    screen -x minecraft/minecraft

As root, you can manually start the minecraft server in a shared minecraft user
screen session via:

    sudo -u minecraft -i bash -c 'screen -dmS minecraft ~/bin/start_minecraft.sh'

Protip: One can run multiple minecraft servers by sourcing different `.env`
files before using `vagrant`.

## License

GPLv3 or ask me nicely if you'd like something else.

## Contributors

* [djcp](http://github.com/djcp)
