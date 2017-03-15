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
packages=(gcc cmake mpc mpfr gmp mure mcnp)
for name in "${packages[@]}"; do
  eval version=\$"$name"_version
  echo Ensuring build of $name-$version ...
  ensure_build $name $version
done
gcc -v
cd /mnt/gluster/mouginot/RNR_TRU_MOX_SOFT
gcc -o RNR_Coeur_Exec RNR_Coeur.cxx -I $MURE_include -I$MURE_ExternalPkg -L$MURE_lib -lMUREpkg -lvalerr -lmctal
./RNR_Coeur_Exec 6.803336573650825949e-04 1.027026225545415034e-01 3.545857904589768544e-02 7.335372455934200927e-04 1.054397330805723759e-01 5.924265358963841030e-03 5.304536709674443663e-03 6.800736129314761957e-03 7.730292213537834486e-04 9.526814737269947986e-03 9.944943353793634505e-04 4.396904541677146804e-03 5.835223910802531030e-05 8.845106742785593923e-05 1.201190905182277424e-03 9.194656192707478066e-04 3.209199863658749588e-04




