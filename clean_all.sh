#!/bin/bash

set -e

script_dir="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
source ${script_dir}/common.sh

rm -rf ${poky_build_dir} ${bitbake_cache_dir} ${sstate_dir} ${dl_dir}