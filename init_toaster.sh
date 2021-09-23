#!/bin/bash

set -e

script_dir="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
source ${script_dir}/common.sh

# setting up Toaster
cd ${poky_dir}
pip3 install --user -r bitbake/toaster-requirements.txt
