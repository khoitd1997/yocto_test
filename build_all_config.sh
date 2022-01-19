#!/bin/bash

script_dir="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

bash "${script_dir}/set_build_config.sh" "debug"

bash "${script_dir}/build.sh"
bash "${script_dir}/expert_scripts/build_apu_toolchain.sh"
bash "${script_dir}/expert_scripts/build_r5_toolchain.sh"

bash "${script_dir}/set_build_config.sh" "debug"