#!/usr/bin/env bash

globals=$( cd $(dirname $0); pwd)/../globals.sh
source $globals

NAME=gromacs
VERSION=4.5.7
URL=ftp://ftp.gromacs.org/pub/gromacs/$NAME-$VERSION.tar.gz

CFG_ARGS='--enable-shared --enable-static --enable-all-static --with-fft=fftw3 --without-xml'
CFG0=
CFG1='--enable-double --program-suffix=_d'

# curl -L $URL | tar zxf -
cd $NAME-$VERSION

for grp in "$CFG0" "$CFG1"; do
    ./configure \
	--prefix=$PREFIX/$NAME/$VERSION \
	$CFG_ARGS \
	$grp
    make $MAKEOPTS
    make check
    $SUDO make install
done


modulefile=$MODULEFILES/$NAME/$VERSION
mkdir -p $(dirname $modulefile)
cat <<EOF>$modulefile
#%Module

set name $NAME
set ver  $VERSION
set pref $PREFIX

set root \$pref/\$name/\$ver

prepend-path PATH               \$root/bin
prepend-path CPATH              \$root/include
prepend-path INCLUDE_PATH       \$root/include
prepend-path C_INCLUDE_PATH     \$root/include
prepend-path LIBRARY_PATH       \$root/lib
prepend-path DYLD_FALLBACK_LIBRARY_PATH  \$root/lib
prepend-path PKG_CONFIG_PATH    \$root/lib/pkgconfig
prepend-path MANPATH            \$root/share/man
EOF
