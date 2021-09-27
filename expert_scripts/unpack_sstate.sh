#!/bin/bash

set -e

script_dir="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

source ${script_dir}/../common.sh

echo "Starting sstate unpack"

mkdir -p ${sstate_dir}
rm -rf ${sstate_dir}/*
cd ${sstate_dir}
tar xf ${sstate_package_path}

echo "Finished sstate unpack"