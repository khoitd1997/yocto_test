#!/bin/bash

set -e

err_report() {
    echo "Flash failed!"
    echo 'Press any key to continue... '
    read r
}

trap 'err_report' ERR

image_name="initramfs-image"
image_path="${DEPLOY_DIR_IMAGE}/${image_name}-${MACHINE}.wic"

echo "Please specify the block device name(ex: sda, sdb, etc)"
read block_device_name

if ! lsblk -a | grep "${block_device_name}"; then
    echo "Invalid block device: ${block_device_name}"
    err_report
    exit 1
fi

block_device_path=/dev/${block_device_name}

sudo umount -v ${block_device_path}?* || true

echo "Flashing raw image"

sudo dd if="${image_path}" of="${block_device_path}" status=progress bs=4096

sync