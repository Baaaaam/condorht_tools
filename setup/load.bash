#!/bin/bash

set -e
export args="$@"
export args=" "$args" "

source ./common.bash
source ./build_funcs.bash
set_dirs
set_versions
set_env
export make_install_tarballs=false
export jobs=12

# Cleanup directories
rm -rf $build_dir $install_dir
mkdir -p $dist_dir $build_dir $install_dir $copy_dir $DATAPATH

# Make sure all the dependencies are built
packages=(mcnp mure)
for name in "${packages[@]}"; do
  eval version=\$"$name"_version
  echo Ensuring build of $name-$version ...
  ensure_build $name $version
done
echo $PATH

mkdir MOX
cd MOX
cp -v /mnt/gluster/mouginot/MOX/*.* .
cp -r /mnt/gluster/mouginot/MOX/ReactionList .
g++  -o MOX MOX.cc -I$MURE_include -I$MURE_ExternalPkg -L$MURE_lib -lMUREpkg -lvalerr -lmctal -fopenmp
./MOX 0.03 0.5 5 19 5 5 6 4 2 5 1 2 5 5 5 5
