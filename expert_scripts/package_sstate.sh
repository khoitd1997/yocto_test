#!/bin/bash

set -e

script_dir="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
source ${script_dir}/../common.sh

echo "Starting sstate packaging"

rm -f ${sstate_package_path}
cd ${sstate_dir}
tar -czf ${sstate_package_path} *

echo "Finished sstate packaging"