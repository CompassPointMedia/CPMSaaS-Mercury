
Vagrant.configure("2") do |config|

  config.vm.box = "inflectionpoint/throwaway2"

  config.vm.provider "virtualbox" do |vb|
    vb.customize [ "modifyvm", :id, "--uart1", "off" ]
    vb.customize [ "modifyvm", :id, "--uart2", "off" ]
    vb.customize [ "modifyvm", :id, "--uart3", "off" ]
    vb.customize [ "modifyvm", :id, "--uart4", "off" ]
  end

  config.vm.network "private_network", ip: "192.168.33.201"
  config.vm.synced_folder ".", "/var/www", :mount_options => ["dmode=777", "fmode=757"]


  dir = File.expand_path("..", __FILE__)
  puts "DIR: #{dir}"

  config.vm.provision "shell", path: File.join(dir, "install-assets/files.sh")

  config.vm.provision "shell", path: File.join(dir, "install-assets/apache2.sh")

  config.vm.provision "shell", inline: "source /etc/apache2/envvars && service apache2 restart && echo \"Apache (re)start complete\"",
    run: "always"

end
