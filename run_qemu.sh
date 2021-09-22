#!/bin/bash

set -e

script_dir="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
source ${script_dir}/common.sh

source_oe_init_script

# NOTE: for ssh, do ssh root@localhost -p 2222
# by default, seems to forward port 22, 23 to localhost 2222, 2323

CYAN='\033[0;36m'
NC='\033[0m'
printf "${CYAN}Use 'Ctrl+a c' to get to QEMU shell, then enter 'quit' to quit\n${NC}"
runqemu \
    qemuarm64 core-image-minimal ext4 nographic serial slirp