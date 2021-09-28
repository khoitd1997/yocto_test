require build_path.inc

# NOTE: Add extra Python import here
OE_EXTRA_IMPORTS_append = " math multiprocessing "

INHERIT += "buildhistory buildstats" 

# the local.conf of individual build config should set these variables
# this is just a placeholder
KSD_BUILD_NAME ?= "defaultname"

# MACHINE = "qemuarm64"
MACHINE = "zcu106-zynqmp"
# MACHINE = "qemuzynq"

DISTRO = "petalinux"

PACKAGE_CLASSES ?= "package_ipk"

SDKMACHINE = "x86_64"

USER_CLASSES_append = "buildstats image-mklibs image-prelink"

PATCHRESOLVE = "noop"

PACKAGECONFIG_append_pn-qemu-system-native = " sdl"

CONF_VERSION = "1"

### BUILD INFRASTRUCTURE CONFIG
BB_DISKMON_DIRS = "\
    STOPTASKS,${TMPDIR},1G,100K \
    STOPTASKS,${DL_DIR},1G,100K \
    STOPTASKS,${SSTATE_DIR},1G,100K \
    STOPTASKS,/tmp,100M,100K \
    ABORT,${TMPDIR},100M,1K \
    ABORT,${DL_DIR},100M,1K \
    ABORT,${SSTATE_DIR},100M,1K \
    ABORT,/tmp,10M,1K"

BB_NUMBER_THREADS = "${@max(math.floor(multiprocessing.cpu_count() * 0.75), 1)}"

# NOTE: Every machine-distro comb should have a unique val for these
KSD_BUILD_ID_STR = "${MACHINE}-${DISTRO}-${KSD_BUILD_NAME}"
TMPDIR = "${TOPDIR}/${KSD_BUILD_ID_STR}/tmp"
BUILDHISTORY_DIR = "${TOPDIR}/${KSD_BUILD_ID_STR}/buildhistory"

SSTATE_DIR = "${KSD_CACHE_DIR}/sstate"
SSTATE_MIRRORS = "file://.* file://${SSTATE_DIR}/PATH"

DL_DIR = "${KSD_CACHE_DIR}/dl"
BB_GENERATE_MIRROR_TARBALLS = "1"
CACHE = "${KSD_CACHE_DIR}/bitbake_cache"

IMAGE_FSTYPES = "ext4"
IMAGE_FSTYPES_remove = "tar.bz2"

EXTRA_IMAGE_FEATURES_remove = "ssh-server-dropbear"

# KERNEL_FEATURES_append = "features/test_features/test.scc"

# KCONFIG_CONFIG_COMMAND = "xconfig"

XILINX_VER_MAIN = "2020.1"
XILINX_VIVADO_DESIGN_SUIT = "/tools/Xilinx/Vivado/2020.1"

PMU_FIRMWARE_DEPLOY_DIR = "${DEPLOY_DIR_IMAGE}"
PMU_FIRMWARE_IMAGE_NAME = "pmu-firmware-${MACHINE}"

# Fix for Xilinx issue:
# https://github.com/Xilinx/meta-xilinx/pull/24
DEFAULTTUNE = "cortexa53"
