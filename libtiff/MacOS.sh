#!/usr/bin/env bash

globals=$( cd $(dirname $0); pwd)/../globals.sh
source $globals

NAME=libtiff
BNAME=tiff
VERSION=4.0.3
URL=http://download.osgeo.org/$NAME/$BNAME-$VERSION.tar.gz

curl -L $URL | tar zxf -
cd $BNAME-$VERSION
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
prepend-path DYLD_FALLBACK_LIBRARY_PATH  \$root/lib
prepend-path PKG_CONFIG_PATH    \$root/lib/pkgconfig
prepend-path MANPATH            \$root/share/man

setenv SW_ROOT_${NAME}          \$root

EOF
