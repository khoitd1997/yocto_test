#!/bin/bash

set -e

script_dir="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
source ${script_dir}/common.sh

if [ -z "${1}" ]; then
    build_config="debug"
else
    build_config="${1}"
fi

cd ${poky_dir}
rm -rf ${poky_build_dir}
source oe-init-build-env

# NOTE: bitbake sometimes timeout or do weird things
# wipe the build directories to start at clean slate
rm -rf ${poky_build_conf_dir}/*

cp ${custom_conf_dir}/${build_config}/* ${poky_build_conf_dir}
cp ${custom_conf_dir}/include/* ${poky_build_conf_dir}
# cp -r ${custom_conf_dir}/classes ${poky_build_dir}

# start_toaster

bitbake core-image-minimal
# bitbake core-image-sato