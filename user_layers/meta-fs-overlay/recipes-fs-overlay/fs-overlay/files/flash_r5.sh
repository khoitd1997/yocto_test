#!/bin/sh

set -e

mkdir -p "/lib/firmware"

r5_image_path="${1}"
r5_image_name=$(basename "${r5_image_path}")

set +e
echo stop > /sys/class/remoteproc/remoteproc0/state
set -e

cp "${r5_image_path}" "/lib/firmware"

echo "${r5_image_name}" > /sys/class/remoteproc/remoteproc0/firmware
echo start > /sys/class/remoteproc/remoteproc0/state

rm -f "/lib/firmware/${r5_image_name}"