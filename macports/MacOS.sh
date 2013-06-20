#!/usr/bin/env bash

globals=$( cd $(dirname $0); pwd)/../globals.sh
source $globals

NAME=macports
VERSION=2.1.3
URL=https://distfiles.macports.org/MacPorts/MacPorts-$VERSION.tar.bz2

curl $URL | tar jxf -
cd MacPorts-$VERSION
pref=$PREFIX/$NAME/$VERSION
./configure --prefix=$pref
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

prepend-path PATH     \$root/bin
prepend-path INFOPATH \$root/share/info
prepend-path MANPATH  \$root/share/man
c
EOF
