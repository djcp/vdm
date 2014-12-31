MINECRAFT_HOSTNAME = (ENV['MINECRAFT_HOSTNAME'] || 'default')
VM_SIZE = (ENV['VM_SIZE'] || '1GB')
TOKEN = ENV['DIGITALOCEAN_TOKEN']
REGION = (ENV['REGION'] || 'nyc3')
EULA_ACCEPTED = (ENV['EULA_ACCEPTED'] || 'false')

VAGRANTFILE_API_VERSION = '2'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = 'digital_ocean'
  config.ssh.private_key_path = '~/.ssh/id_dsa'
  config.vm.provider :digital_ocean do |provider|
    provider.hostname = MINECRAFT_HOSTNAME
    provider.size = VM_SIZE
    provider.token = TOKEN
    provider.image = 'debian-7-0-x64'
    provider.region = REGION
  end

  config.vm.define MINECRAFT_HOSTNAME
  config.vm.provision 'shell', path: 'base_dependencies.sh'

  if EULA_ACCEPTED != 'false'
    config.vm.provision 'shell',
      path: 'accept_eula_and_boot.sh'
  else
    puts 'eula not accepted, you must manually configure and start minecraft.'
  end
end
