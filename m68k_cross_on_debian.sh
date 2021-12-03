#!/bin/bash
CONFIGURE="n"
CONFIG_FILE="ct-ng-m68k-config.txt"

CROSSTOOL_BUILD_DIR=".crosstoolbuild"
CROSSTOOL_DIR=$(realpath ".crosstool")
CROSSCHAIN_BUILD_DIR=".crosschainbuild"

need_package()
{
    REQUIRED_PKG=$1
    PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG|grep "install ok installed")
    echo Checking for $REQUIRED_PKG: $PKG_OK
    if [ "" = "$PKG_OK" ]; then
        #echo "No $REQUIRED_PKG. Setting up $REQUIRED_PKG."
        sudo apt-get --yes install $REQUIRED_PKG
    fi
}

prepare()
{
    # needed
    # INFO  :: Master packages: android-ndk autoconf automake avr-libc binutils bison cloog dtc duma elf2flt expat gcc gdb gettext glibc glibc-ports gmp gnuprumcu isl libelf libiconv libtool linux ltrace m4 make mingw-w64 moxiebox mpc mpfr musl ncurses newlib-nano newlib picolibc strace uClibc zlib

    declare -a arr=("autoconf" 
                "automake" "libncurses-dev"
                "python-devel"
     #           "libstdc++"
                )

    for i in "${arr[@]}"
    do
        need_package $i
    done

    need_package help2man
    need_package libtool-bin
    #need_package libtool
    need_package flex
    need_package texinfo
    need_package bison

    need_package flex
    need_package texinfo
    need_package flex
    need_package unzip
    need_package bzip2
    need_package make
    need_package xz-utils
    need_package patch
    need_package gawk
    #need_package ncurses
}

build_crosstool()
{
    prepare
    rm -rf ${CROSSTOOL_BUILD_DIR}
    git clone https://github.com/crosstool-ng/crosstool-ng ${CROSSTOOL_BUILD_DIR}

    cd ${CROSSTOOL_BUILD_DIR}
    ./bootstrap
    ./configure --prefix=${CROSSTOOL_DIR}

    make
    make install

    cd ..
    rm -rf ${CROSSTOOL_BUILD_DIR}
}

build_cross()
{
    rm -rf ${CROSSCHAIN_BUILD_DIR}
    mkdir ${CROSSCHAIN_BUILD_DIR}
    cp ct-ng-m68k-config.txt ${CROSSCHAIN_BUILD_DIR}/.config
    cd ${CROSSCHAIN_BUILD_DIR}

    if [[ "$CONFIGURE" =~ ^([yY][eE][sS]|[yY])$ ]]
    then
        ${CROSSTOOL_DIR}/bin/ct-ng help
        ${CROSSTOOL_DIR}/bin/ct-ng m68k-unknown-elf
        ${CROSSTOOL_DIR}/bin/ct-ng menuconfig
    else
        echo "using saved configuration"
    fi

    ${CROSSTOOL_DIR}/bin/ct-ng build
}

build_crosstool
build_cross
echo "export PATH=${CROSSTOOL_DIR}/bin:\$PATH"
