#!/bin/bash
CONFIGURE="n"
CONFIG_FILE="ct-ng-m68k-config.txt"

CROSSTOOL_BUILD_DIR=".crosstoolbuild"
CROSSTOOL_DIR=$(realpath ".crosstool")
CROSSCHAIN_BUILD_DIR=".crosschainbuild"


get_packager_used()
{
    PKG_MANAGER="none"

    if [ -x "$(command -v apt-get)" ]; then 
        PKG_MANAGER="apt-get"
    elif [ -x "$(command -v dnf)" ]; then
        PKG_MANAGER="dnf"
    fi 

    echo $PKG_MANAGER
}

need_package()
{
    REQUIRED_PKG=$1
    PKG_MANAGER=$(get_packager_used)

    if [ "$PKG_MANAGER" = "apt-get" ]; then
        PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG|grep "install ok installed")

    elif [ "$PKG_MANAGER" = "dnf" ]; then
        PKG_OK=$(dnf list installed "$REQUIRED_PKG" | grep "$REQUIRED_PKG")
    fi 

    echo Checking for $REQUIRED_PKG: $PKG_OK
    if [ "" = "$PKG_OK" ]; then
        #echo "No $REQUIRED_PKG. Setting up $REQUIRED_PKG."
        sudo $PKG_MANAGER -y install $REQUIRED_PKG
    fi
}

prepare()
{
    # needed
    # INFO  :: Master packages: android-ndk autoconf automake avr-libc binutils bison cloog dtc duma elf2flt expat gcc gdb gettext glibc glibc-ports gmp gnuprumcu isl libelf libiconv libtool linux ltrace m4 make mingw-w64 moxiebox mpc mpfr musl ncurses newlib-nano newlib picolibc strace uClibc zlib

    tools=("autoconf" "automake" "flex" "texinfo" "help2man" "unzip" "bzip2" "make" "help2man" "patch" )
    libs=("libncurses-dev" "libstdc++" "python-devel")
    apt_packages=("xz-utils" "libtool-bin")
    dnf_packages=("libtool" "ncurses")

    if [ $(get_packager_used) = "dnf" ]; then 
        packages=(${tools[@]} ${dnf_packages[@]})

    elif [ $(get_packager_used) = "apt-get" ]; then  
        packages=(${tools[@]} ${apt_packages[@]})
    fi

    echo ${arr[@]}
    #exit

    for i in "${packages[@]}"
    do
        echo $i
        need_package $i
    done

    #need_package libtool-bin
    #need_package gawk
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

    ${CROSSTOOL_DIR}/bin/ct-ng upgradeconfig

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
