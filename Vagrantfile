
Vagrant.configure("2") do |config|

  config.vm.box = "inflectionpoint/throwaway2"

  config.vm.network "private_network", ip: "192.168.33.103"
  config.vm.synced_folder ".", "/var/www", :mount_options => ["dmode=777", "fmode=757"]


  dir = File.expand_path("..", __FILE__)
  puts "DIR: #{dir}"

  config.vm.provision "shell", path: File.join(dir, "install-assets/files.sh")

  config.vm.provision "shell", path: File.join(dir, "install-assets/apache2.sh")

end
