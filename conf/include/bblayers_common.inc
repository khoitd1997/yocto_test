require build_path.inc

# NOTE: Can't use custom variables in bblayers related files
# since it would require inheriting another file
# to keep things simple, just use built-in variables for bblayers related

# POKY_BBLAYERS_CONF_VERSION is increased each time build/conf/bblayers.conf
# changes incompatibly
POKY_BBLAYERS_CONF_VERSION = "2"

BBFILES ?= ""

BBLAYERS = " \
    ${KSD_POKY_DIR}/meta \
    ${KSD_POKY_DIR}/meta-poky \
    \
    ${KSD_USER_LAYERS_DIR}/meta-user-package \
    ${KSD_USER_LAYERS_DIR}/meta-kernel-customization \
    \
    ${KSD_META_OPENEMBEDDED_DIR}/meta-perl \
    ${KSD_META_OPENEMBEDDED_DIR}/meta-python \
    ${KSD_META_OPENEMBEDDED_DIR}/meta-filesystems \
    ${KSD_META_OPENEMBEDDED_DIR}/meta-gnome \
    ${KSD_META_OPENEMBEDDED_DIR}/meta-multimedia \
    ${KSD_META_OPENEMBEDDED_DIR}/meta-networking \
    ${KSD_META_OPENEMBEDDED_DIR}/meta-webserver \
    ${KSD_META_OPENEMBEDDED_DIR}/meta-xfce \
    ${KSD_META_OPENEMBEDDED_DIR}/meta-initramfs \
    ${KSD_META_OPENEMBEDDED_DIR}/meta-oe \
    \
    ${KSD_THIRD_PARTY_LAYERS_DIR}/meta-qt5 \
    \
    ${KSD_THIRD_PARTY_LAYERS_DIR}/meta-xilinx/meta-xilinx-bsp \
    ${KSD_THIRD_PARTY_LAYERS_DIR}/meta-xilinx/meta-xilinx-pynq \
    ${KSD_THIRD_PARTY_LAYERS_DIR}/meta-xilinx/meta-xilinx-standalone \
    ${KSD_THIRD_PARTY_LAYERS_DIR}/meta-xilinx/meta-xilinx-contrib \
    ${KSD_THIRD_PARTY_LAYERS_DIR}/meta-xilinx-tools \
    ${KSD_THIRD_PARTY_LAYERS_DIR}/meta-petalinux \
    ${KSD_THIRD_PARTY_LAYERS_DIR}/meta-openamp \
"

BBLAYERS_NON_REMOVABLE ?= " \
    ${KSD_POKY_DIR}/meta \
"

BBPATH = "${TOPDIR}"