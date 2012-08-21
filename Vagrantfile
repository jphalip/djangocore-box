# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
  config.vm.box = "lucid32"
  config.vm.host_name = "djangocore"

  # Shared folders
  hosthome = "#{ENV['HOME']}/"
  config.vm.share_folder("v-root", "/djangocore-box", ".", :nfs => true)
  config.vm.share_folder("v-root", "/django", "../django", :nfs => true)
  config.vm.share_folder("v-host", "/home/vagrant/.hosthome", hosthome)

  config.vm.network :hostonly, "1.2.3.4"

  # Provisioning -------------------------------------------------------------

  # We first make sure that the expected version of Chef is installed.
  config.vm.provision :shell, :inline => "/vagrant/provisioning/shell/install-chef.sh 10.12.0"

  config.vm.provision :chef_solo do |chef|
      chef.cookbooks_path = "provisioning/chef"
      chef.log_level = :debug
      chef.run_list = [
          "recipe[basics::init_ssh]",
          "recipe[basics::init_gitconfig]",
          "recipe[basics::init_system]"
      ]
  end

  config.vm.provision :chef_solo do |chef|
      chef.cookbooks_path = "provisioning/chef"
      chef.log_level = :debug
      chef.run_list = [
          "recipe[git]",
          "recipe[openssl]",
          "recipe[memcached]",
          "recipe[mysql]",
          "recipe[mysql::client]",
          "recipe[mysql::server]",
          "recipe[postgresql]",
          "recipe[postgresql::client]",
          "recipe[postgresql::server]"
      ]
      chef.json.merge!({
          :mysql => {
              :server_root_password => 'secret',
              :bind_address => '127.0.0.1'
          },
          :postgresql => {
              :password => {:postgres => 'secret'}
          }})
  end

  config.vm.provision :shell, :inline => "su vagrant -c '/vagrant/provisioning/shell/install-python.sh 2.4.6 2.5.6 2.6.5 2.7.1 3.2.3 --default 2.7.1'"
  config.vm.provision :shell, :inline => "su vagrant -c /vagrant/provisioning/shell/install-gis.sh"
  config.vm.provision :shell, :inline => "su vagrant -c '/vagrant/provisioning/shell/install-pysqlite.sh 2.4 2.5 2.6'"  # pysqlite ships with Python >= 2.7
  config.vm.provision :shell, :inline => "su vagrant -c /vagrant/provisioning/shell/create-databases.sh"
end
