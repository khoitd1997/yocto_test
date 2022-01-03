#!/bin/bash
# Wipe the build directory(BUT NOT THE CACHE) and then do the build

set -e

script_dir="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
source "${script_dir}/common.sh"

echo "REMOVING YOCTO BUILD DIRECTORY"
rm -rf "${poky_build_dir}"

echo "STARTING BUILD"
source "${script_dir}/build.sh"