#!/bin/bash

set -e

script_dir="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
source "${script_dir}/common.sh"

# NOTE: bitbake sometimes timeout or do weird things
# wiping the build directories sometimes fix that
echo "REMOVING ALL YOCTO BUILD FILES"
clean_all

echo "STARTING BUILD"
source "${script_dir}/build.sh"