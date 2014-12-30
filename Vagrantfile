MINECRAFT_HOSTNAME = (ENV['MINECRAFT_HOSTNAME'] || 'minecraft')
VM_SIZE = (ENV['VM_SIZE'] || '1GB')
TOKEN = ENV['DIGITALOCEAN_TOKEN']
REGION = (ENV['REGION'] || 'nyc3')

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

  config.vm.provision 'shell', path: 'base_dependencies.sh'
end
