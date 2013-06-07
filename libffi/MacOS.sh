#!/usr/bin/env bash

globals=$( cd $(dirname $0); pwd)/../globals.sh
source $globals

NAME=libffi
VERSION=3.0.13
URL=ftp://sourceware.org/pub/$NAME/$NAME-$VERSION.tar.gz

# curl -L $URL | tar zxf -
# cd $NAME-$VERSION
# ./configure --prefix=$PREFIX/$NAME/$VERSION
# make $MAKEOPTS
# $SUDO make install

modulefile=$MODULEFILES/$NAME/$VERSION
mkdir -p $(dirname $modulefile)
cat <<EOF>$modulefile
#%Module

set name $NAME
set ver  $VERSION
set pref $PREFIX

set root \$pref/\$name/\$ver

set inc  \$root/lib/\$name-\$ver/include

prepend-path CPATH              \$inc
prepend-path INCLUDE_PATH       \$inc
prepend-path C_INCLUDE_PATH     \$inc
prepend-path LIBRARY_PATH       \$root/lib
prepend-path LD_LIBRARY_PATH    \$root/lib
prepend-path DYLD_FALLBACK_LIBRARY_PATH  \$root/lib
prepend-path PKG_CONFIG_PATH    \$root/lib/pkgconfig
prepend-path INFOPATH           \$root/share/info
prepend-path MANPATH            \$root/share/man
EOF
