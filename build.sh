#!/bin/bash

set -e

script_dir="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
source ${script_dir}/common.sh

if [ -z "${1}" ]; then
    build_config="debug"
else
    build_config="${1}"
fi

# NOTE: bitbake sometimes timeout or do weird things
# wipe the build directories to start at clean slate
# during experimenting
echo "REMOVING YOCTO BUILD"
# rm -rf ${poky_build_dir}
mkdir -p ${poky_build_conf_dir}

cp ${custom_conf_dir}/${build_config}/* ${poky_build_conf_dir}
cp ${custom_conf_dir}/include/* ${poky_build_conf_dir}
# cp -r ${custom_conf_dir}/classes ${poky_build_dir}

source_oe_init_script

# time bitbake procrank
time bitbake core-image-minimal
# bitbake core-image-sato

# TODO(kd): Compile log file is at
# /home/kd/yocto_test/poky/build/tmp/work/cortexa57-poky-linux/procrank/0.1-r0/temp/