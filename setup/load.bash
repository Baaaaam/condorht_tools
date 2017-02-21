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
packages=(gcc cmake mpc mpfr gmp python root)
for name in "${packages[@]}"; do
  eval version=\$"$name"_version
  echo Ensuring build of $name-$version ...
  ensure_build $name $version
done

echo $LD_LIBRARY_PATH

cd /mnt/gluster/mouginot/TRU_MOX_SOFT/XS/Generate
echo "1"
gcc -o Train_XS  `root-config --cflags` Train_XS.cxx `root-config --glibs` -lTMVA
echo "2"
./Train_XS 1


