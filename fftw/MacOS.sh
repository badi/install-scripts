#!/usr/bin/env bash

globals=$( cd $(dirname $0); pwd)/../globals.sh
source $globals

NAME=fftw
VERSION=3.3.3
URL=http://www.fftw.org/$NAME-$VERSION.tar.gz

CFG_ARGS='--enable-shared --enable-static --enable-threads'
CFG0='--enable-single --enable-sse'
CFG1='--enable-sse2'

curl -L $URL | tar zxf -
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
prepend-path INFOPATH           \$root/share/info
prepend-path MANPATH            \$root/share/man
EOF
