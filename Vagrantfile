# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # Required: vagrant plugin install vagrant-omnibus vagrant-berkshelf
  config.omnibus.chef_version = :latest
  config.berkshelf.enabled    = true
  config.berkshelf.berksfile_path = './Berksfile'

  # More at https://atlas.hashicorp.com/boxes/search
  config.vm.box = "chef/ubuntu-14.04"

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  config.vm.provision "chef_solo" do |chef|
    chef.add_recipe "chef-stats_ag"
    chef.json = {}
  end
end
