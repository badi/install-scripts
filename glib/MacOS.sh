#!/usr/bin/env bash

globals=$( cd $(dirname $0); pwd)/../globals.sh
source $globals

NAME=glib
MAJOR=2.36
MINOR=2
VERSION=$MAJOR.$MINOR
URL=http://ftp.acc.umu.se/pub/gnome/sources/$NAME/$MAJOR/$NAME-$VERSION.tar.xz

P1='raw.github.com/gist/5393707/5a9047ab7838709084b36242a44471b02d036386/glib-configurable-paths.patch'
P2='trac.macports.org/export/95596/trunk/dports/devel/glib2/files/patch-configure.diff'
PATCHES=($P1 $P2)

curl -L $URL | unxz - | tar xf -
cd $NAME-$VERSION

### Apply fixes
# patches taken from homebrew:
# github.com/mxcl/homebrew/blob/master/Library/Formula/glib.rb
curl -L "$P1" | patch -p1 
curl -L "$P2" | patch
# fix for new mtime on makefile.in:
# groups.google.com/forum/?fromgroups#!topic/bugzillagnometelconnect4688-bugzillagnometelconnect4688/Qa-nJ1aQkN0
find . -type f -name Makefile.in -exec touch {} \; 

./configure \
    --prefix=$PREFIX/$NAME/$VERSION \
    --enable-static --enable-shared \
    --disable-man # docbook is required for this
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

prepend-path CPATH              \$root/include/gio-unix-2.0
prepend-path INCLUDE_PATH       \$root/include/gio-unix-2.0
prepend-path C_INCLUDE_PATH     \$root/include/gio-unix-2.0

prepend-path CPATH              \$root/include/glib-2.0
prepend-path INCLUDE_PATH       \$root/include/glib-2.0
prepend-path C_INCLUDE_PATH     \$root/include/glib-2.0
prepend-path CPATH              \$root/lib/glib-2.0/include
prepend-path INCLUDE_PATH       \$root/lib/glib-2.0/include
prepend-path C_INCLUDE_PATH     \$root/lib/glib-2.0/include

prepend-path LIBRARY_PATH       \$root/lib
prepend-path DYLD_FALLBACK_LIBRARY_PATH  \$root/lib
prepend-path PKG_CONFIG_PATH    \$root/lib/pkgconfig

setenv SW_ROOT_${NAME} \$root

EOF
