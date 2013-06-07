#!/usr/bin/env bash

globals=$( cd $(dirname $0); pwd)/../globals.sh
source $globals

NAME=pcre
VERSION=8.33
URL=ftp://ftp.csx.cam.ac.uk/pub/software/programming/$NAME/$NAME-$VERSION.tar.bz2

curl -L $URL | tar zxf -
cd $NAME-$VERSION
./configure --prefix=$PREFIX/$NAME/$VERSION
make $MAKEOPTS
make check
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
