# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
  config.vm.box = "djangocore-box-1.0"
  config.vm.box_url = "https://dl.dropbox.com/u/3364022/Temp/djangocore-box-1.0.box"
  config.vm.host_name = "djangocore"

  config.vm.forward_port 8000, 8000
  config.vm.forward_port 22, 2222
  config.ssh.forward_agent = true

  # Shared folders
  hosthome = "#{ENV['HOME']}/"
  config.vm.share_folder("v-djangocore-box", "/djangocore-box", ".", :nfs => true)
  config.vm.share_folder("v-django", "/django", "../django", :nfs => true)
  config.vm.share_folder("v-hosthome", "/home/vagrant/.hosthome", hosthome)

  # Host-only network required to use NFS shared folders
  config.vm.network :hostonly, "1.2.3.4"
end
