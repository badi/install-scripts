#!/usr/bin/env bash

globals=$( cd $(dirname $0); pwd)/../globals.sh
source $globals

NAME=gettext
VERSION=0.18.2
URL=http://ftp.gnu.org/pub/gnu/$NAME/$NAME-$VERSION.tar.gz    

curl -L $URL | tar zxf -
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

prepend-path PATH               \$root/bin
prepend-path CPATH              \$root/include
prepend-path INCLUDE_PATH       \$root/include
prepend-path C_INCLUDE_PATH     \$root/include
prepend-path LIBRARY_PATH       \$root/lib
prepend-path DYLD_FALLBACK_LIBRARY_PATH  \$root/lib
prepend-path INFOPATH           \$root/share/info
prepend-path MANPATH            \$root/share/man

setenv SW_ROOT_${NAME}          \$root
EOF
