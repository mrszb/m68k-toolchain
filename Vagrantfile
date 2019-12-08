#https://fedoraproject.org/wiki/Vagrant

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "fedora/31-cloud-base"
  config.vm.box_version = "31.20191023.0"

  # config.vm.network "forwarded_port", guest: 5000, host: 80

  # This is an optional plugin that, if installed, updates the host's /etc/hosts
  # file with the hostname of the guest VM. In Fedora it is packaged as
  # vagrant-hostmanager
  if Vagrant.has_plugin?("vagrant-hostmanager")
      config.hostmanager.enabled = true
      config.hostmanager.manage_host = true
  end

  #config.vm.synced_folder ".", "/vagrant", disabled: true
  #config.vm.synced_folder ".", "/home/vagrant/devel", type: "sshfs", sshfs_opts_append: "-o nonempty"
  config.vm.synced_folder "./devel", "/home/vagrant/devel", type: "rsync"

  # bootstrap and run with ansible
  #config.vm.provision "shell", inline: "sudo dnf -y update"
  config.vm.provision "shell", inline: <<-SHELL
  dnf update -y

  # ubuntu
  # libgmp-dev libmpfr-dev libmpc-dev texinfo libc6-dev-i386

  # fedora
  dnf install -y gmp-devel mpfr-devel libmpc-devel texinfo glibc-devel.i686

  dnf install -y dos2unix wget make gcc-c++ cmake
  SHELL
 
  #config.vm.provision "shell", inline: "ls ."
  # config.vm.provision :shell, :privileged => false, :path => "build_m68k.sh"
  config.vm.provision :shell, :privileged => false, :path => "cleanup_build.sh"
  
  #config.vm.provision "ansible" do |ansible|
  #    ansible.playbook = "devel/ansible/vagrant-playbook.yml"
  #end

  config.vm.provider "virtualbox" do |v|
    v.name = "m68k"
    v.gui = true
    v.memory = 1024
    v.cpus = 4
    # v.vm.share_folder "devel", "/home/vagrant/devel", "./devel", transient: true
  end

end