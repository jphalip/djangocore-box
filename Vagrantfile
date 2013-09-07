# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
  config.vm.box = "djangocore-box-1.1"
  config.vm.box_url = "https://www.djangoproject.com/m/vms/djangocore-box-1.1.box"
  config.vm.host_name = "djangocore"

  config.ssh.forward_agent = true

  # Shared folders
  hosthome = "#{ENV['HOME']}/"
  utilize_nfs = (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) == nil
  
  config.vm.share_folder("v-djangocore-box", "/djangocore-box", ".", :nfs => utilize_nfs)
  config.vm.share_folder("v-django", "/django", "../django", :nfs => utilize_nfs)
  config.vm.share_folder("v-sandbox", "/sandbox", "../sandbox", :nfs => utilize_nfs)
  config.vm.share_folder("v-hosthome", "/home/vagrant/.hosthome", hosthome)
  

  # Host-only network required to use NFS shared folders
  config.vm.network :hostonly, "1.2.3.4"

  # Start the virtual display (for Selenium tests)
  config.vm.provision :shell, :inline => "su vagrant -c /djangocore-box/provisioning/shell/virtual-display.sh"
end
