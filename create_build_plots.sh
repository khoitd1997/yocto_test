#!/bin/bash
set -e

script_dir="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
source ${script_dir}/common.sh


source_oe_init_script -q

${poky_dir}/scripts/contrib/bb-perf/buildstats-plot.sh -s cutime | gnuplot -p
${poky_dir}/scripts/contrib/bb-perf/buildstats-plot.sh -s cutime -S | gnuplot -p

cd ${poky_build_history_dir}
# TODO: Use this file installed-package-sizes.txt to produce more readable results


# NOTE: Log for each package is at /home/kd/yocto_test/poky/build/tmp/work/qemuarm64-poky-linux/linux-yocto/5.10.47+gitAUTOINC+82899c6a71_52bcc5b234-r0/temp

# ksize.py