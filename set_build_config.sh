#!/bin/bash
# used for changing current build config
# this decides which set of config files(ie layer.conf, local.conf)
# to use for a build

set -e

script_dir="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
source "${script_dir}/common.sh"

build_config="${1}"
if [ -z "${build_config}" ]; then
    echo "Error: No build config name given!"
    echo "Usage: set_build_config.sh build_config_name"
    exit 1
else
    build_config_dir="${custom_conf_dir}/${build_config}"
    if [ -d "${build_config_dir}" ]; then
        set_build_config "${build_config}"
        print_important_message "Current build config: ${build_config}\n"
    else
        echo "Error: Build config directory for config \"${build_config}\" doesn't exist!"
        echo "Please create the directory ${build_config_dir} and fill it with necessary config files"
    fi
fi
