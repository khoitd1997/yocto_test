#!/bin/bash
# used for checking what current build config is used

set -e

script_dir="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
source ${script_dir}/common.sh

get_build_config
curr_build_config="${get_build_config_retval}"
if [ -z "${curr_build_config}" ]; then
    echo "Build config is not set! Please use set_build_config.sh to set it"
else
    print_important_message "Current build config: ${curr_build_config}\n"
fi

