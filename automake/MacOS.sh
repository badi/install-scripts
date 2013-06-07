#!/usr/bin/env bash

globals=$( cd $(dirname $0); pwd)/../globals.sh
source $globals

NAME=automake
VERSION=1.13
URL=http://ftp.gnu.org/gnu/$NAME/$NAME-$VERSION.tar.xz

curl -L $URL | unxz - | tar xf -
cd $NAME-$VERSION
./configure --prefix=$PREFIX/$NAME/$VERSION --enable-static --enable-shared 
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

setenv       SW_ROOT_${NAME} \$root
EOF
