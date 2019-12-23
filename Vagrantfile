require 'win32ole'
require 'yaml'

file_system = WIN32OLE.new("Scripting.FileSystemObject")
drives      = file_system.Drives
current_dir = File.dirname(File.expand_path(__FILE__))
default_config_file = "#{current_dir}/default-config.yml"
yaml_config = YAML.load_file(default_config_file)

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = yaml_config['vm_box']
  #config.vm.box = "fedora/31-cloud-base"
  config.vm.box_version = "31.20191023.0"

  # This is an optional plugin that, if installed, updates the host's /etc/hosts
  # file with the hostname of the guest VM. In Fedora it is packaged as
  # vagrant-hostmanager
  if Vagrant.has_plugin?("vagrant-hostmanager")
      config.hostmanager.enabled = true
      config.hostmanager.manage_host = true
  end

  config.vagrant.plugins = ["vagrant-vbguest"]
  if Vagrant.has_plugin?("vagrant-vbguest")
    config.vbguest.auto_update = yaml_config['vagrant_vbguest_enabled']
    config.vbguest.no_remote = true
  end  


  # bootstrap and 
  # (later) run with ansible
  config.vm.provision "shell", inline: "sudo dnf -y update"
  config.vm.provision "shell", inline: <<-SHELL

  # ubuntu
  # libgmp-dev libmpfr-dev libmpc-dev texinfo libc6-dev-i386

  # fedora
  dnf install -y gmp-devel mpfr-devel libmpc-devel texinfo glibc-devel.i686
  dnf install -y dos2unix wget make gcc-c++ cmake

  SHELL
 
  config.vm.provision :shell, :privileged => false, inline: 'mkdir -p devel'
  config.vm.provision :shell, :privileged => false, :path => "build_m68k.sh"
  config.vm.provision :shell, :privileged => false, :path => "cleanup_build.sh"
  config.vm.synced_folder "./.dev", "/home/vagrant/devel",type:"virtualbox", :mount_options => ["rw"]

  $script = <<-SCRIPT
    echo 'export PATH=$HOME/x-tools/m68k-elf/bin:$PATH' >> ~/.bashrc
  SCRIPT

  config.vm.provision :shell, inline: $script, privileged: false

  #config.vm.provision "ansible" do |ansible|
  #    ansible.playbook = "devel/ansible/vagrant-playbook.yml"
  #end

  config.vm.provider "virtualbox" do |v|
    v.name = "m68k"
    v.gui = true
    v.memory = 1024
    v.cpus = 4
  end

end