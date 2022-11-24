# Mercury installer for FlexionPoint Database as a Service (DaaS) application
# @author: Samuel Fullman

Vagrant.configure("2") do |config|

  config.vm.box = "inflectionpoint/throwaway2"
  # change this as updates are made but this seems stable
  config.vm.box_version = "0.0.16"

  config.vm.provider "virtualbox" do |vb|
    vb.customize [ "modifyvm", :id, "--uart1", "off" ]
    vb.customize [ "modifyvm", :id, "--uart2", "off" ]
    vb.customize [ "modifyvm", :id, "--uart3", "off" ]
    vb.customize [ "modifyvm", :id, "--uart4", "off" ]
  end

  ## @comment NOTE!! Don't change IP unless you change it in php/Vagrant.class.php also!
  ## it can be changed in the installer.sh interview or install-assets/defaults.json file (see README)
  config.vm.network "private_network", ip: "192.168.33.214"


  config.vm.synced_folder ".", "/var/www", :mount_options => ["dmode=777", "fmode=757"]


  dir = File.expand_path("..", __FILE__)
  puts "DIR: #{dir}"

  config.vm.provision "shell", path: File.join(dir, "install-assets/files.sh")


  config.vm.provision "shell", path: File.join(dir, "install-assets/apache2.sh")


  config.vm.provision "shell", path: File.join(dir, "install-assets/restart.sh"),
    run: "always"

end
