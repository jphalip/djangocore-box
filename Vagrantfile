# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
  config.vm.box = "djangocore-box-1.1-alpha"
  config.vm.box_url = "https://dl.dropbox.com/u/3364022/djangocore-box/djangocore-box-1.1-alpha.box"
  config.vm.host_name = "djangocore"

  config.ssh.forward_agent = true

  # Shared folders
  hosthome = "#{ENV['HOME']}/"
  config.vm.share_folder("v-djangocore-box", "/djangocore-box", ".", :nfs => true)
  config.vm.share_folder("v-django", "/django", "../django", :nfs => true)
  config.vm.share_folder("v-sandbox", "/sandbox", "../sandbox", :nfs => true)
  config.vm.share_folder("v-hosthome", "/home/vagrant/.hosthome", hosthome)

  # Host-only network required to use NFS shared folders
  config.vm.network :hostonly, "1.2.3.4"
end
