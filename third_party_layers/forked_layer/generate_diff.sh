#!/bin/bash

script_dir="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

diff_out_dir="${script_dir}/diff"
rm -rf "${diff_out_dir}"
mkdir "${diff_out_dir}"

cd /tmp
rm -rf meta-openamp meta-xilinx-tools meta-xilinx

git clone https://github.com/Xilinx/meta-openamp.git -b xlnx-rel-v2021.2
diff -bur --exclude=.git "${script_dir}/meta-openamp-xlnx-rel-v2021.2" meta-openamp > "${diff_out_dir}/meta-openamp-diff.patch"

git clone https://github.com/Xilinx/meta-xilinx.git -b xlnx-rel-v2021.2
diff -bur --exclude=.git "${script_dir}/meta-xilinx-xlnx-rel-v2021.2" meta-xilinx > "${diff_out_dir}/meta-xilinx-diff.patch"

git clone https://github.com/Xilinx/meta-xilinx-tools.git -b xlnx-rel-v2021.2
diff -bur --exclude=.git "${script_dir}/meta-xilinx-tools-xlnx-rel-v2021.2" meta-xilinx-tools > "${diff_out_dir}/meta-xilinx-tools-diff.patch"