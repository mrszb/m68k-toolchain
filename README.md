# m68k-toolchain

## Vagrant Cross

build

`export VAGRANT_LOG='info'`

`vagrant up`


in powershell:
`>PS`

`[Environment]::SetEnvironmentVariable("VAGRANT_LOG", "info", "User")`

`vagrant up --debug 2>&1 | Tee-Object -FilePath ".\vagrant.log`


run
`vagrant ssh`

`[vagrant@localhost ~]$ $CC -v`

## Docker Cross
Docker on Windows using Vagrant and accessible via Ubuntu on Windows (WSL)
[GitHub vagrant-wsl-docker](https://github.com/haxorof/vagrant-wsl-docker)

test it:

windows

`set DOCKER_HOST=tcp://127.0.0.1:2375`

`docker info`

build

`docker build -t m68kcross .`

run
`docker run -i -t m68kcross`

`docker run -i -t m68kcross  /bin/bash ./entry-point.sh`

`docker run -i -v /c/Users:/data -t m68kcross /bin/bash`
