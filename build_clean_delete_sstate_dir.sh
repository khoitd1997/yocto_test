#!/bin/bash

set -e

script_dir="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
source "${script_dir}/common.sh"

echo "REMOVING YOCTO BUILD AND SSTATE DIRECTORY"
clean_sstate

echo "STARTING BUILD"
source "${script_dir}/build.sh"