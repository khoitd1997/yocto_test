#!/bin/bash

set -e

script_dir="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
source "${script_dir}/common.sh"

bash "${script_dir}/build.sh"
bash "${script_dir}/flash_image.sh"