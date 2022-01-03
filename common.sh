#!/bin/bash

# when sourcing the script, different method needed to get path
# to current script
if [ -n "$BASH_SOURCE" ]; then
    common_script_dir=$(dirname $(readlink -f ${BASH_SOURCE}))
else
    common_script_dir="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
fi

build_var_storage_file_path="${common_script_dir}/.build_var_storage"

cache_dir="${common_script_dir}/cache"

sstate_package_path="${common_script_dir}/sstate.tar.gz"
sstate_dir="${cache_dir}/sstate"

dl_dir="${cache_dir}/dl"

default_bb_image_target="initramfs-image"

poky_dir="${common_script_dir}/poky"
poky_build_dir="${poky_dir}/build"
poky_tmp_dir="${poky_build_dir}/tmp"
poky_work_dir="${poky_tmp_dir}/work"
poky_build_conf_dir="${poky_build_dir}/conf"

third_party_layer_dir="${common_script_dir}/third_party_layers"
user_layer_dir="${common_script_dir}/user_layers"

meta_user_package_dir="${user_layer_dir}/meta-user-package"

# TODO(kd): make this more dynamic
poky_build_history_dir="${poky_build_dir}/buildhistory/images/qemuarm64/glibc/${default_bb_image_target}"

custom_conf_dir="${common_script_dir}/conf"

oe_init_script_path="${poky_dir}/oe-init-build-env"

bitbake_cache_dir="${cache_dir}/bitbake_cache"


toaster_url="localhost:8223"
toaster_args="nobuild webport=${toaster_url}"

function print_important_message {
    local cyan_color='\033[0;31m'
    local reset_color='\033[0m'
    printf "${cyan_color}${1}${reset_color}"
}

function clean_all {
    rm -rf "${poky_build_dir}" "${cache_dir}"
}

function clean_sstate {
    rm -rf "${poky_build_dir}" "${sstate_dir}"
}

# use "-q" option to have stdout(but not stderr) directed to /dev/null
# shellcheck disable=SC2120
function source_oe_init_script {
    local curr_pwd=${PWD}

    # cd to poky_dir to make sure the build directory is created properly
    # technically could call source ${oe_init_script_path} build_dir
    # but that might not work with some shell
    cd "${poky_dir}" || exit
    if [ "${1}" = "-q" ]; then
        shift
        source "${oe_init_script_path}" > /dev/null
    else
        source "${oe_init_script_path}"
    fi

    cd "${curr_pwd}" || exit
}

function init_repo {
    local curr_pwd=${PWD}

    cd "${common_script_dir}"
    git submodule init
    git submodule update

    cd "${curr_pwd}"
}

# turn on variables to help debugging the Yocto buildsystem easier
function enable_bb_debug_flag {
    export BB_VERBOSE_LOGS=1
}

# used to open a vscode window at the log directory of a recipe
function open_recipe_work_folder {
    local curr_pwd=${PWD}
    local recipe_name="${1}"

    cd "${poky_work_dir}"
    echo "Searching in: ${poky_work_dir}"
    local res=$(find . -maxdepth 2 -type d -name "${recipe_name}")

    if [ -z "${res}" ]; then
        echo "Can't find recipe with name: ${recipe_name}"
    else
        echo "Found recipes, opening in vscode"
        code ${res}
    fi

    cd "${curr_pwd}"
}

function set_build_config {
    local build_config="${1}"

    mkdir -p "${poky_build_conf_dir}"
    rm -rf "${poky_build_conf_dir}/*"

    ln -sf "${custom_conf_dir}/${build_config}/*" "${poky_build_conf_dir}"
    ln -sf "${custom_conf_dir}/include/*" "${poky_build_conf_dir}"

    echo "KSD_CURR_BUILD_CONFIG=${build_config}" > "${build_var_storage_file_path}"
}

function get_build_config {
    if [ -f "${build_var_storage_file_path}" ]; then
        source "${build_var_storage_file_path}"
        get_build_config_retval=${KSD_CURR_BUILD_CONFIG}
    else
        get_build_config_retval=""
    fi
}

function util_show_xconfig {
    local curr_pwd=${PWD}

    source_oe_init_script

    bitbake -c xconfig "${1}"

    cd "${curr_pwd}"
}

function util_generate_defconfig {
    local curr_pwd=${PWD}

    source_oe_init_script

    bitbake -c savedefconfig "${1}"

    cd "${curr_pwd}"
}

# TODO: Verify if the comment is true for u-boot
# used for generating cfg fragment for use with 
# .scc files
# you must first use menuconfig to edit config you want
# then use this function to generate the diff fragment
function util_generate_cfg_fragment {
    local curr_pwd=${PWD}

    source_oe_init_script

    bitbake -c diffconfig "${1}"

    cd "${curr_pwd}"
}

function util_build_incremental {
    local curr_pwd=${PWD}

    source_oe_init_script

    bitbake "${1}"

    cd "${curr_pwd}"
}

### KERNEL RELATED FUNCTIONS ###
function show_kernel_xconfig {
    util_show_xconfig virtual/kernel
}
function generate_kernel_defconfig {
    util_generate_defconfig virtual/kernel
}
function generate_kernel_cfg_fragment {
    util_generate_cfg_fragment virtual/kernel
}
function build_incremental_kernel {
    util_build_incremental virtual/kernel
}

### UBOOT RELATED FUNCTIONS ###
function show_uboot_xconfig {
    util_show_xconfig virtual/bootloader
}
function generate_uboot_defconfig {
    util_generate_defconfig virtual/bootloader
}
# TODO(kd): Check this one
function generate_uboot_cfg_fragment {
    util_generate_cfg_fragment virtual/bootloader
}

function build_incremental_uboot {
    util_build_incremental virtual/bootloader
}

# TODO(kd): Devtool workflow for kernel
# https://www.yoctoproject.org/docs/latest/kernel-dev/kernel-dev.html#applying-patches