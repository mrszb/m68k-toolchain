require 'win32ole'
require 'yaml'

file_system = WIN32OLE.new("Scripting.FileSystemObject")
drives      = file_system.Drives
current_dir = File.dirname(File.expand_path(__FILE__))
default_config_file = "#{current_dir}/default-config.yml"
yaml_config = YAML.load_file(default_config_file)

VAGRANTFILE_API_VERSION = "2"
RAM = 4096
CPUS = 4

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = yaml_config['vm_box']
  config.vm.box = "fedora/32-cloud-base"
  config.vm.box_version = "32.20200422.0"

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
  #config.vm.provision "shell", inline: "sudo dnf -y update"
  config.vm.provision "shell", inline: <<-SHELL

  if [ -f /etc/os-release ]; then
    # freedesktop.org and systemd
    . /etc/os-release
    OSID=$ID
  fi

  echo $OSID
  SHELL
 
  config.vm.provision :shell, :privileged => false, inline: 'mkdir -p devel'
  config.vm.provision :shell, :privileged => true, :path => "install_gcc_build_dependencies.sh"
  config.vm.provision :shell, :privileged => true, :path => "build_xtools.sh"
  config.vm.provision :shell, :privileged => false, :path => "cleanup_build.sh"
  #config.vm.synced_folder "./.dev", "/home/vagrant/devel", type:"virtualbox", :mount_options => ["rw"]

  $script = <<-SCRIPT
    echo 'export PATH=$HOME/x-tools/m68k-elf/bin:$PATH' >> ~/.bashrc
    echo 'export CC=/home/vagrant/x-tools/m68k-elf/bin/m68k-elf-gcc' >> ~/.bashrc
    echo 'export CXX=/home/vagrant/x-tools/m68k-elf/bin/m68k-elf-g++' >> ~/.bashrc
  SCRIPT

  config.vm.provision :shell, inline: $script, privileged: false

  #config.vm.provision "ansible" do |ansible|
  #    ansible.playbook = "devel/ansible/vagrant-playbook.yml"
  #end

  config.vm.provider "virtualbox" do |v|
    v.name = "m68k-cross-compiler"
    v.gui = false
    #v.memory = RAM
    #v.cpus = CPUS
    v.customize ['modifyvm', :id, '--memory', RAM]
    v.customize ['modifyvm', :id, '--cpus', CPUS]
  end

end