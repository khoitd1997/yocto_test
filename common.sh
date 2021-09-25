#!/bin/bash

# when sourcing the script, different method needed to get path
# to current script
if [ -n "$BASH_SOURCE" ]; then
    common_script_dir=$(dirname $(readlink -f ${BASH_SOURCE}))
else
    common_script_dir="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
fi
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

# use "-q" option to have stdout(but not stderr) directed to /dev/null
function source_oe_init_script {
    local curr_pwd=${PWD}

    # cd to poky_dir to make sure the build directory is created properly
    # technically could call source ${oe_init_script_path} build_dir
    # but that might not work with some shell
    cd ${poky_dir}
    if [ "${1}" = "-q" ]; then
        shift
        source ${oe_init_script_path} > /dev/null
    else
        source ${oe_init_script_path}
    fi

    cd ${curr_pwd}
}