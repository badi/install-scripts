#!/usr/bin/env bash

globals=$( cd $(dirname $0); pwd)/../globals.sh
source $globals

NAME=xz
VERSION=5.0.4
URL=http://tukaani.org/xz/$NAME-$VERSION.tar.bz2

curl -L $URL | tar jxf -
cd $NAME-$VERSION
./configure --prefix=$PREFIX/$NAME/$VERSION
make $MAKEOPTS
$SUDO make install

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
prepend-path LD_LIBRARY_PATH    \$root/lib
prepend-path PKG_CONFIG_PATH    \$root/lib/pkgconfig
prepend-path MANPATH            \$root/share/man
EOF
