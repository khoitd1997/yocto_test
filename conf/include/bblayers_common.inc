# NOTE: Can't use custom variables in bblayers related files
# since it would require inheriting another file
# to keep things simple, just use built-in variables for bblayers related

# POKY_BBLAYERS_CONF_VERSION is increased each time build/conf/bblayers.conf
# changes incompatibly
POKY_BBLAYERS_CONF_VERSION = "2"

BBFILES ?= ""

BBLAYERS = " \
  ${TOPDIR}/../meta \
  ${TOPDIR}/../meta-poky \
  ${TOPDIR}/../meta-yocto-bsp \
  "

BBPATH = "${TOPDIR}"