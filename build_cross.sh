#!/usr/bin/env bash
# see http://www.ifp.illinois.edu/~nakazato/tips/xgcc.html

function pause(){
echo "pause $*"
#read -p "$*"
}

echo target $TARGET
echo host $HOST
echo binutils $VER_BINUTILS
echo gcc $VER_GCC
echo newlib $VER_NEWLIB $DATE_NEWLIB
echo gdb $VER_GDB

NEWLIB_FILENAME=newlib-${VER_NEWLIB}${DATE_NEWLIB}

EXTRA_GCC_FLAGS="--disable-nls --disable-shared --disable-threads --disable-libssp"
NOF_PROC=`nproc`
MAKE="make -j ${NOF_PROC}"
WGET="wget --progress=bar:force"

if [ ! -f binutils-${VER_BINUTILS}.tar.gz ] ; then
  echo "Getting binutils (${VER_BINUTILS})"
   ${WGET} http://ftp.gnu.org/gnu/binutils/binutils-${VER_BINUTILS}.tar.gz
fi

if [ ! -f gcc-${VER_GCC}.tar.gz ] ; then
  echo "Getting gcc (${VER_GCC})"
  ${WGET} ftp://ftp.gnu.org/gnu/gcc/gcc-${VER_GCC}/gcc-${VER_GCC}.tar.gz
fi

if [ ! -f ${NEWLIB_FILENAME}.tar.gz ] ; then
  echo "Getting newlib (${VER_NEWLIB})"
  ${WGET} ftp://sourceware.org/pub/newlib/${NEWLIB_FILENAME}.tar.gz
fi

if [ ! -f ${NEWLIB_FILENAME}.tar.gz ] ; then
  echo "Getting newlib (${VER_NEWLIB})"
  ${WGET} http://downloads.sourceforge.net/project/devkitpro/sources/newlib/${NEWLIB_FILENAME}.tar.gz
fi

if [ ! -f gdb-${VER_GDB}.tar.gz ] ; then
  echo "Getting gdb (${VER_GDB})"
  ${WGET} http://ftp.gnu.org/gnu/gdb/gdb-${VER_GDB}.tar.gz
fi

pause 'downloads done'

tarflags=zxf

rm -rf build src
mkdir src build build/binutils build/gcc build/newlib build/gcc-full build/gdb

#########################################################################
# build binutils

tar ${tarflags} binutils-${VER_BINUTILS}.tar.gz -C src

cd build/binutils
pwd
../../src/binutils-${VER_BINUTILS}/configure --target=$TARGET --host=$HOST --prefix=$PREFIX --disable-nls 2>&1 | tee ../binutils-configure.log && echo "All good!" || echo "Something's awry"
${MAKE} all  2>&1 | tee ../binutils-make-all.log
${MAKE} install 2>&1 | tee ../binutils-make-install.log
cd ../..

pause 'binutils done'

#########################################################################
# build bootstrap gcc

#tar jxf gcc-${VER_GCC}.tar.bz2 -C src
tar ${tarflags} gcc-${VER_GCC}.tar.gz -C src

cd build/gcc
export PATH=$PATH:$PREFIX/bin
../../src/gcc-${VER_GCC}/configure --target=$TARGET --host=$HOST --prefix=$PREFIX --without-headers --with-newlib --with-gnu-as --with-gnu-ld 2>&1 | tee ../bootstrap-configure.log && echo "All good!" || echo "Something's awry"
${MAKE} all-gcc  2>&1 | tee ../bootstrap-make-all-gcc.log
${MAKE} install-gcc | tee ../bootstrap-make-install-gcc.log
pause 'bootstrap gcc done'

${MAKE} all-target-libgcc  2>&1 | tee ../bootstrap-make-all-target-libgcc.log
${MAKE} install-target-libgcc | tee ../bootstrap-make-install-target-libgcc.log
pause 'libgcc done'

cd ../..

# libgloss see http://www.embecosm.com/appnotes/ean9/html/ch03s01.html

tar ${tarflags} ${NEWLIB_FILENAME}.tar.gz -C src
cd build/newlib
../../src/${NEWLIB_FILENAME}/configure --disable-libgloss --target=$TARGET --host=$HOST --prefix=$PREFIX 2>&1 | tee ../newlib-configure.log && echo "All good!" || echo "Something's awry"
${MAKE} all 2>&1 | tee ../newlib-make-all.log
${MAKE} install 2>&1 | tee ../newlib-make-install.log
cd ../..

pause 'newlib done'

#tar jxvf gcc-${VER_GCC}.tar.bz2 -C src
cd build/gcc-full
../../src/gcc-${VER_GCC}/configure --target=$TARGET --host=$HOST --prefix=$PREFIX $EXTRA_GCC_FLAGS --enable-languages=c,c++ --with-newlib --with-gnu-as --with-gnu-ld 2>&1 | tee ../gcc-configure.log && echo "All good!" || echo "Something's awry"

${MAKE} all-gcc  2>&1 | tee ../gcc-make-all.log
${MAKE} install-gcc  | tee ../gcc-make-install.log
pause 'gcc done'

${MAKE} all-target-libstdc++-v3 2>&1 | tee ../gcc-make-all-target-libstdc++-v3.log
${MAKE} install-target-libstdc++-v3 | tee ../gcc-make-install-target-libstdc++-v3.log
pause 'libstdc++-v3 done'

cd ../..

tar ${tarflags} gdb-${VER_GDB}.tar.gz -C src
cd build/gdb 
../../src/gdb-${VER_GDB}/configure --target=$TARGET --host=$HOST --prefix=$PREFIX  2>&1 | tee ../gdb-configure.log && echo "All good!" || echo "Something's awry"
${MAKE} all  2>&1 | tee ../gdb-make-all.log
${MAKE} install | tee ../gdb-make-install.log
cd ../..
