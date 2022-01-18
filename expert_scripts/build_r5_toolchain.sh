#!/bin/bash

set -e

script_dir="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
source "${script_dir}/../common.sh"

get_build_config
prev_build_config="${get_build_config_retval}"

source_oe_init_script

set_build_config "r5_toolchain"

bitbake meta-toolchain

# set the build config back to before
if [ -n "${prev_build_config}" ]; then
    set_build_config "${prev_build_config}"
fi