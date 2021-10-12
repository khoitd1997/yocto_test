#!/bin/bash
# Wipe the build directory(BUT NOT THE CACHE) and then do the build

set -e

script_dir="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
source ${script_dir}/common.sh

# NOTE: bitbake sometimes timeout or do weird things
# wiping the build directories sometimes fix that
echo "REMOVING YOCTO BUILD DIRECTORY"
rm -rf ${poky_build_dir}

source ${script_dir}/build.sh