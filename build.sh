#!/bin/bash

set -e

script_dir="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
source ${script_dir}/common.sh

# NOTE: bitbake sometimes timeout or do weird things
# wipe the build directories to start at clean slate
# during experimenting
echo "REMOVING YOCTO BUILD"
# rm -rf ${poky_build_dir}

update_yocto_config

source_oe_init_script

# time bitbake procrank
time bitbake core-image-minimal
# bitbake core-image-sato

# TODO(kd): Compile log file is at
# /home/kd/yocto_test/poky/build/tmp/work/cortexa57-poky-linux/procrank/0.1-r0/temp/

# TODO(kd): Kernel source at
# ~/yocto_test/poky/build/tmp/work-shared/qemuarm64/kernel-source