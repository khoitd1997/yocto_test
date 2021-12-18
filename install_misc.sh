#!/bin/bash
# used for installing various things
# example: ./install_misc.sh "/home/kd/Downloads/xilinx-zcu102-v2020.1-final.bsp"

set -e

script_dir="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
source "${script_dir}/common.sh"

# ZCU 102 BSP file can be downloaded from page like this:
# https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/embedded-design-tools/archive.html
if [ -z "${1}" ]; then
    echo "usage: install_misc.sh <path-to-xilinx-zcu102-bsp>"
    exit 1
fi
bsp_file=$(readlink -f "${1}")

tar -O -xf "${bsp_file}" \
    xilinx-zcu102-2020.1/pre-built/linux/images/pmu_rom_qemu_sha3.elf > "${meta_user_package_dir}/recipes-devtools/pmu-rom-qemu/files/pmu-rom.elf"