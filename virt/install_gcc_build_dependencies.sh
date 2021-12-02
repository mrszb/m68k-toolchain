  #!/bin/bash
  
  if [ -f /etc/os-release ]; then
    # freedesktop.org and systemd
    . /etc/os-release
    OSID=$ID
  fi

  #https://wiki.osdev.org/Preparing_GCC_Build
  
  case $OSID in
    ubuntu* | debian* | raspbian)
      apt-get install -y build-essential
      apt-get install -y bison flex
      apt-get install -y dos2unix 

      apt-get -y install libgmp-dev libmpfr-dev libmpc-dev texinfo 
      
      #not on raspbian (optional ?)
      apt-get -y install libc6-dev-i386

      # optional libraries
      apt-get -y install libisl-dev
      ;;

    fedora*)
      dnf install -y gmp-devel mpfr-devel libmpc-devel texinfo glibc-devel.i686
      dnf install -y dos2unix wget make gcc-c++ cmake
      ;;
  esac
