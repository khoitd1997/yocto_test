require build_path.inc

# POKY_BBLAYERS_CONF_VERSION is increased each time build/conf/bblayers.conf
# changes incompatibly
POKY_BBLAYERS_CONF_VERSION = "2"

BBFILES ?= ""

# cause issue with gstreamer in poky distro build
# ${KSD_THIRD_PARTY_LAYERS_DIR}/meta-petalinux

# Non-essential Xilinx layers
# ${KSD_THIRD_PARTY_LAYERS_DIR}/meta-xilinx/meta-xilinx-pynq
# ${KSD_THIRD_PARTY_LAYERS_DIR}/meta-xilinx/meta-xilinx-standalone
# ${KSD_THIRD_PARTY_LAYERS_DIR}/meta-xilinx/meta-xilinx-contrib
# ${KSD_THIRD_PARTY_LAYERS_DIR}/meta-openamp
# ${KSD_THIRD_PARTY_LAYERS_DIR}/meta-virtualization

# Non-essential Yocto layers
# ${KSD_META_OPENEMBEDDED_DIR}/meta-xfce 
# ${KSD_META_OPENEMBEDDED_DIR}/meta-gnome
# ${KSD_META_OPENEMBEDDED_DIR}/meta-initramfs
# ${KSD_THIRD_PARTY_LAYERS_DIR}/forked_layer/meta-xilinx/meta-xilinx-bsp 
# ${KSD_THIRD_PARTY_LAYERS_DIR}/forked_layer/meta-xilinx-tools 

# ${KSD_USER_LAYERS_DIR}/meta-my-ultra96

BBLAYERS = " \
    ${KSD_POKY_DIR}/meta \
    ${KSD_POKY_DIR}/meta-poky \
    \
    ${KSD_USER_LAYERS_DIR}/meta-user-package \
    ${KSD_USER_LAYERS_DIR}/meta-my-distro \
    ${KSD_USER_LAYERS_DIR}/meta-kernel-customization \
    \
    ${KSD_USER_LAYERS_DIR}/meta-common-bsp \
    ${KSD_USER_LAYERS_DIR}/meta-myboard-bsp \
    \
    ${KSD_META_OPENEMBEDDED_DIR}/meta-perl \
    ${KSD_META_OPENEMBEDDED_DIR}/meta-python \
    ${KSD_META_OPENEMBEDDED_DIR}/meta-filesystems \
    ${KSD_META_OPENEMBEDDED_DIR}/meta-multimedia \
    ${KSD_META_OPENEMBEDDED_DIR}/meta-networking \
    ${KSD_META_OPENEMBEDDED_DIR}/meta-webserver \
    ${KSD_META_OPENEMBEDDED_DIR}/meta-oe \
    \
    ${KSD_THIRD_PARTY_LAYERS_DIR}/forked_layer/meta-openamp-xlnx-rel-v2021.2 \
    ${KSD_THIRD_PARTY_LAYERS_DIR}/forked_layer/meta-xilinx-xlnx-rel-v2021.2/meta-xilinx-standalone \
    ${KSD_THIRD_PARTY_LAYERS_DIR}/forked_layer/meta-xilinx-xlnx-rel-v2021.2/meta-xilinx-bsp \
    ${KSD_THIRD_PARTY_LAYERS_DIR}/forked_layer/meta-xilinx-tools-xlnx-rel-v2021.2 \
"

BBLAYERS_NON_REMOVABLE ?= " \
    ${KSD_POKY_DIR}/meta \
"

BBPATH = "${TOPDIR}"