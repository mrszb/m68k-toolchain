#!/usr/bin/env bash

export TARGET=m68k-elf
#export PREFIX=/home/${USER}/.local
export PREFIX=/home/${USER}/x-tools/${TARGET}
export PATH="$PREFIX/bin:$PATH"

export VER_BINUTILS=2.37
export VER_GCC=11.2.0
export VER_NEWLIB=4.1.0
#export DATE_NEWLIB=".20181231"
export DATE_NEWLIB=""
export VER_GDB=11.1


./build_cross.sh