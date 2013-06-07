#!/usr/bin/env bash

globals=$( cd $(dirname $0); pwd)/../globals.sh
source $globals

NAME=wget
VERSION=1.14
URL=http://ftp.gnu.org/gnu/wget/$NAME-$VERSION.tar.gz

 curl $URL | tar zxf -
cd $NAME-$VERSION
./configure --prefix=$PREFIX/$NAME/$VERSION --with-ssl=openssl
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
