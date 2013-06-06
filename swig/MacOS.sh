#!/usr/bin/env bash

globals=$( cd $(dirname $0); pwd)/../globals.sh
source $globals

NAME=swig
VERSION=2.0.10
URL=http://prdownloads.sourceforge.net/swig/$NAME-$VERSION.tar.gz

curl -L $URL | tar zxf -
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

prepend-path PATH    \$root/bin
prepend-path MANPATH \$root/share/man
EOF
