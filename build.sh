#!/bin/bash

set -e

script_dir="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
source ${script_dir}/common.sh

cd ${poky_dir}
source oe-init-build-env

cp ${custom_conf_dir}/local.conf ${poky_build_conf_dir}
cp ${custom_conf_dir}/bblayers.conf ${poky_build_conf_dir}

# bitbake core-image-minimal
bitbake core-image-sato