#!/bin/bash

set -e


err_report() {
    echo "Flash failed!"
    echo 'Press any key to continue... '
    read r
}

trap 'err_report $LINENO' ERR

image_path="${1}"

rootfs_flash_dir="/media/${USER}/rootfs"

sudo find "${rootfs_flash_dir}" -mindepth 1 -name . -o -prune -exec rm -rf -- {} +

sudo tar -xaf "${image_path}" -C "${rootfs_flash_dir}"