#!/bin/bash
# script to initialize yocto tools as well as custom commands 
# into the current shell

script_dir=$(dirname $(readlink -f ${BASH_SOURCE}))
source "${script_dir}/common.sh"

source_oe_init_script