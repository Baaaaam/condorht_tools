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
packages=(mcnp smure)
for name in "${packages[@]}"; do
  eval version=\$"$name"_version
  echo Ensuring build of $name-$version ...
  ensure_build $name $version
done
echo $PATH

mcnp6


cp $dist_dir/REP_MOX/REP_MOX.tar .
tar -xvf REP_MOX.tar
g++ -o MOX MOX.cc -I$MURE_include -I$MURE_ExternalPkg -L$MURE_lib -lMUREpkg -lvalerr -lmctal -fopenmp
./MOX 1 2 3 4 5 6 7 7
