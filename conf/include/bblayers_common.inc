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
  ${KSD_POKY_DIR}/meta-yocto-bsp \
  \
  ${KSD_USER_LAYERS_DIR}/meta-user-package \
  ${KSD_REPO_ROOT_DIR}/meta-qt5 \
  ${KSD_USER_LAYERS_DIR}/meta-kernel-customization \
  "

BBPATH = "${TOPDIR}"