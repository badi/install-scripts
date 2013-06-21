#!/usr/bin/env bash

globals=$( cd $(dirname $0); pwd)/../globals.sh
source $globals

NAME=namd
VERSION=2.9
UGLY_NAME=NAMD_${VERSION}_MacOSX-x86_64-multicore
URL=https://www-s.ks.uiuc.edu/Research/namd/2.9/download/513856/$UGLY_NAME.tar.gz

dst=$PREFIX/$NAME
curl -L $URL | tar zxf -
test ! -d $dst && $SUDO mkdir -p $dst
$SUDO mv $UGLY_NAME $dst/$VERSION


modulefile=$MODULEFILES/$NAME/$VERSION
mkdir -p $(dirname $modulefile)
cat <<EOF>$modulefile
#%Module

set name $NAME
set ver  $VERSION
set pref $PREFIX

set root \$pref/\$name/\$ver

prepend-path PATH     \$root

EOF
