#!/bin/bash

script_dir="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

diff_out_dir="${script_dir}/diff"
rm -rf "${diff_out_dir}"
mkdir "${diff_out_dir}"

cd /tmp
rm -rf meta-openamp meta-xilinx-tools meta-xilinx

git clone https://github.com/Xilinx/meta-openamp.git
cd meta-openamp && git checkout 670161c5d246ba6af293e274b7fd5b34f9a44701 && cd /tmp
diff -bur --exclude=.git "${script_dir}/meta-openamp-xlnx-rel-v2021.2" meta-openamp > "${diff_out_dir}/meta-openamp-diff.patch"

git clone https://github.com/Xilinx/meta-xilinx.git
cd meta-xilinx && git checkout 054cb2cb4c3ffe868ade68369433027989571cf6 && cd /tmp
diff -bur --exclude=.git "${script_dir}/meta-xilinx-xlnx-rel-v2021.2" meta-xilinx > "${diff_out_dir}/meta-xilinx-diff.patch"

git clone https://github.com/Xilinx/meta-xilinx-tools.git
cd meta-xilinx-tools && git checkout 9be31b43df41ec245f969c2fc65f56c6e910d752 && cd /tmp
diff -bur --exclude=.git "${script_dir}/meta-xilinx-tools-xlnx-rel-v2021.2" meta-xilinx-tools > "${diff_out_dir}/meta-xilinx-tools-diff.patch"