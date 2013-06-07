#!/usr/bin/env bash

globals=$( cd $(dirname $0); pwd)/../globals.sh
source $globals

NAME=emacs
VERSION=24.3
URL=http://mirrors.syringanetworks.net/gnu/emacs/$NAME-$VERSION.tar.gz

curl -L $URL | tar zxf -
cd $NAME-$VERSION
./configure --prefix=$PREFIX/$NAME/$VERSION --with-jpeg=no --with-gif=no --with-tiff=no --without-x
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
EOF
