# m68k-toolchain

>PS
export VAGRANT_LOG='info'

[Environment]::SetEnvironmentVariable("VAGRANT_LOG", "info", "User")
vagrant up --debug 2>&1 | Tee-Object -FilePath ".\vagrant.log"

vagrant up
vagrant ssh