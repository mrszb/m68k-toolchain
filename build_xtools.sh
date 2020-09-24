#!/usr/bin/env bash

export TARGET=m68k-elf
#export PREFIX=/home/${USER}/.local
export PREFIX=/home/${USER}/x-tools/${TARGET}
export PATH="$PREFIX/bin:$PATH"

export VER_BINUTILS=2.35.1
export VER_GCC=10.2.0
export VER_NEWLIB=3.3.0
#export DATE_NEWLIB=".20181231"
export DATE_NEWLIB=""
export VER_GDB=9.2


./build_cross.sh