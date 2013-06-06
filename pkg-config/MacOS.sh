#1/usr/bin/env bash

globals=$( cd $(dirname $0); pwd)/../globals.sh
source $globals

NAME=pkg-config
VERSION=0.27.1
URL=http://pkgconfig.freedesktop.org/releases/$NAME-$VERSION.tar.gz

curl $URL | tar zxf -
cd $NAME-$VERSION
./configure --prefix=$PREFIX/$NAME/$VERSION --with-internal-glib
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

prepend-path PATH    \$root/bin
prepend-path MANPATH \$root/share/man
EOF
