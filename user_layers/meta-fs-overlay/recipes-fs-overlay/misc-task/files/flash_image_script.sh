#!/bin/bash

set -e


err_report() {
    echo "Flash failed!"
    echo 'Press any key to continue... '
    read r
}

trap 'err_report $LINENO' ERR

image_name="initramfs-image"
image_path="${DEPLOY_DIR_IMAGE}/${image_name}-${MACHINE}.tar.gz"

boot_flash_dir="/media/${USER}/BOOT"
rootfs_flash_dir="/media/${USER}/rootfs"

find "${boot_flash_dir}" -mindepth 1 -name . -o -prune -exec rm -rf -- {} +
cd "${DEPLOY_DIR_IMAGE}"
cp -v boot.bin boot.scr "fitImage-initramfs" "${boot_flash_dir}"

sudo find "${rootfs_flash_dir}" -mindepth 1 -name . -o -prune -exec rm -rf -- {} +
sudo tar -xaf "${image_path}" -C "${rootfs_flash_dir}"

sync