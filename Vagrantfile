# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
  config.vm.box = "djangocore-box-1.0"
  config.vm.box_url = "https://www.djangoproject.com/m/vms/djangocore-box-1.0.box"
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
