#!/bin/bash
# Script to get a bitbake variable's value
# usage: get_bb_var.sh <var_name> [bb_target_name]
# if no bb_target_name is specified, default to core-image-minimal

set -e

script_dir="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
source ${script_dir}/common.sh

defaut_bb_target_name="core-image-minimal"
if [ "$#" -eq 1 ]; then
    var_name="${1}"
    bb_target_name="${defaut_bb_target_name}"
elif [ "$#" -eq 2 ]; then
    var_name="${1}"
    bb_target_name="${2}"
else
    echo "Wrong number of arguments"
    echo "usage: get_bb_var.sh <var_name> [bb_target_name]"
    exit 1
fi

source_oe_init_script -q
bitbake -n -e ${bb_target_name} | grep "^${var_name}"
