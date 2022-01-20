#!/bin/bash

set -e

script_dir="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
source "${script_dir}/../common.sh"

source_oe_init_script

# bitbake meta-toolchain
# bitbake ${bb_task_exp_arg} nativesdk-openssl
bitbake nativesdk-openssl