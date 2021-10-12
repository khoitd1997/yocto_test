#!/bin/bash

set -e

script_dir="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
source ${script_dir}/common.sh

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
time bitbake ${default_bb_image_target}
# time bitbake --continue core-image-minimal
# bitbake --continue core-image-sato

# TODO(kd): Compile log file is at
# /home/kd/yocto_test/poky/build/tmp/work/cortexa57-poky-linux/procrank/0.1-r0/temp/

# TODO(kd): Kernel source at
# ~/yocto_test/poky/build/tmp/work-shared/qemuarm64/kernel-source