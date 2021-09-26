#!/bin/bash

# when sourcing the script, different method needed to get path
# to current script
if [ -n "$BASH_SOURCE" ]; then
    common_script_dir=$(dirname $(readlink -f ${BASH_SOURCE}))
else
    common_script_dir="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
fi

cache_dir="${common_script_dir}/cache"

sstate_package_path="${common_script_dir}/sstate.tar.gz"
sstate_dir="${cache_dir}/sstate"

dl_dir="${cache_dir}/dl"

poky_dir="${common_script_dir}/poky"
poky_build_dir="${poky_dir}/build"
poky_tmp_dir="${poky_build_dir}/tmp"
poky_work_dir="${poky_tmp_dir}/work"
poky_build_conf_dir="${poky_build_dir}/conf"
poky_build_history_dir="${poky_build_dir}/buildhistory/images/qemuarm64/glibc/core-image-minimal"

custom_conf_dir="${common_script_dir}/conf"
kernel_conf_dir="${custom_conf_dir}/kernel"

oe_init_script_path="${poky_dir}/oe-init-build-env"

bitbake_cache_dir="${cache_dir}/bitbake_cache"

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

function init_repo {
    local curr_pwd=${PWD}

    cd ${common_script_dir}
    git submodule init
    git submodule update

    cd ${curr_pwd}
}

# turn on variables to help debugging the Yocto buildsystem easier
function enable_bb_debug_flag {
    export BB_VERBOSE_LOGS=1
}

# used to open a vscode window at the log directory of a recipe
function open_recipe_work_folder {
    local curr_pwd=${PWD}
    local recipe_name="${1}"

    cd ${poky_work_dir}
    echo "Searching in: ${poky_work_dir}"
    local res=$(find . -maxdepth 2 -type d -name "${recipe_name}")

    if [ -z "${res}" ]; then
        echo "Can't find recipe with name: ${recipe_name}"
    else
        echo "Found recipes, opening in vscode"
        code ${res}
    fi

    cd ${curr_pwd}
}

function update_yocto_config {
    mkdir -p ${poky_build_conf_dir}

    cp ${custom_conf_dir}/${build_config}/* ${poky_build_conf_dir}
    cp ${custom_conf_dir}/include/* ${poky_build_conf_dir}
}

function show_kernel_xconfig {
    local curr_pwd=${PWD}

    update_yocto_config
    source_oe_init_script

    bitbake -c menuconfig virtual/kernel

    # bitbake -c xconfig virtual/kernel

    cd ${curr_pwd}
}

function save_kernel_defconfig {
    local curr_pwd=${PWD}

    update_yocto_config
    source_oe_init_script

    bitbake -c savedefconfig virtual/kernel

    cd ${curr_pwd}
}

# used for generating cfg fragment for use with 
# .scc files
# you must first use menuconfig to edit config you want
# then use this function to generate the diff fragment
function generate_kernel_cfg_fragment {
    local curr_pwd=${PWD}

    update_yocto_config
    source_oe_init_script

    bitbake -c diffconfig virtual/kernel

    cd ${curr_pwd}
}

function build_incremental_kernel {
    local curr_pwd=${PWD}

    update_yocto_config
    source_oe_init_script

    bitbake virtual/kernel

    cd ${curr_pwd}
}

# TODO(kd): Should probably rethink this
if [ -z "${1}" ]; then
    export build_config="debug"
else
    export build_config="${1}"
fi

# TODO(kd): Generate kernel patch
# for uncommited changes:
# git diff > my_patch.patch

# TODO(kd): Devtool workflow for kernel
# https://www.yoctoproject.org/docs/latest/kernel-dev/kernel-dev.html#applying-patches