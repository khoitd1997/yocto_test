#!/bin/bash

set -e

script_dir="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
source ${script_dir}/common.sh

# NOTE: bitbake sometimes timeout or do weird things
# wipe the build directories to start at clean slate
# during experimenting
# echo "REMOVING YOCTO BUILD"
# rm -rf ${poky_build_dir}

get_build_config
curr_build_config="${get_build_config_retval}"
if [ -z "${curr_build_config}" ]; then
    echo "Build config is not set! Please use set_build_config.sh to set it"
    exit 1
else
    print_important_message "****Current build config: ${curr_build_config}****\n"
fi

# after a clean_all the conf directory will have been wiped out so use set_build_config to reinitialize it
set_build_config "${curr_build_config}"

source_oe_init_script

# time bitbake procrank
time bitbake core-image-minimal
# bitbake core-image-sato

# TODO(kd): Compile log file is at
# /home/kd/yocto_test/poky/build/tmp/work/cortexa57-poky-linux/procrank/0.1-r0/temp/

# TODO(kd): Kernel source at
# ~/yocto_test/poky/build/tmp/work-shared/qemuarm64/kernel-source