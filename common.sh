#!/bin/bash

common_script_dir="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

sstate_package_path="${common_script_dir}/sstate.tar.gz"
sstate_dir="${common_script_dir}/sstate"

dl_dir="${common_script_dir}/dl"

poky_dir="${common_script_dir}/poky"
poky_build_dir="${poky_dir}/build"
poky_build_conf_dir="${poky_build_dir}/conf"
poky_build_history_dir="${poky_build_dir}/buildhistory/images/qemuarm64/glibc/core-image-minimal"
custom_conf_dir="${common_script_dir}/conf"

oe_init_script_path="${poky_dir}/oe-init-build-env"

bitbake_cache_dir="${common_script_dir}/bitbake_cache"

toaster_url="localhost:8223"
toaster_args="nobuild webport=${toaster_url}"

function start_toaster {
    source toaster stop ${toaster_args}
    source toaster start ${toaster_args}
}

# include cd to make sure we are running in the correct directory
function source_oe_init_script {
    cd ${poky_dir}
    source ${oe_init_script_path}
}