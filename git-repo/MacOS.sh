#!/usr/bin/env bash

globals=$( cd $(dirname $0); pwd)/../globals.sh
source $globals

NAME=git-repo
VERSION=1.19
URL=https://git-repo.googlecode.com/files/repo-$VERSION

pref=$PREFIX/$NAME/$VERSION/bin
$SUDO mkdir -p $pref
$SUDO curl -L $URL -o $pref/$NAME
$SUDO chmod a+x $pref/$NAME

modulefile=$MODULEFILES/$NAME/$VERSION
mkdir -p $(dirname $modulefile)
cat <<EOF>$modulefile
#%Module

set name $NAME
set ver  $VERSION
set pref $PREFIX

set root \$pref/\$name/\$ver

prepend-path PATH     \$root/bin
EOF
