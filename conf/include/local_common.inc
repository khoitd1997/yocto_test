require build_path.inc

# NOTE: Add extra Python import here
OE_EXTRA_IMPORTS_append = " math multiprocessing "

INHERIT += "buildhistory buildstats" 

# the local.conf of individual build config should set these variables
# this is just a placeholder
KSD_BUILD_NAME ?= "defaultname"

# MACHINE = "qemuarm64"
# MACHINE = "zcu102-zynqmp"
MACHINE = "my-zcu102-zynqmp"
# MACHINE = "qemuzynq"
# MACHINE = "zynqmp-generic"

# DISTRO = "petalinux"
DISTRO = "poky"

PACKAGE_CLASSES ?= "package_ipk"

SDKMACHINE = "x86_64"

USER_CLASSES_append = "buildstats image-mklibs image-prelink"

PATCHRESOLVE = "noop"

# PACKAGECONFIG_append_pn-qemu-system-native = " sdl"

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

# unit is KBytes
INITRAMFS_MAXSIZE = "512000"

EXTRA_IMAGE_FEATURES_remove = "ssh-server-dropbear"

# KERNEL_FEATURES_append = "features/test_features/test.scc"

# KCONFIG_CONFIG_COMMAND = "xconfig"

# NOTE: Seems like tools are added to PATH using vivado.bbclass
# seems pretty simple, seems like most of the code is to check if they are there
XILINX_VER_MAIN = "2020.1"
XILINX_VIVADO_DESIGN_SUIT = "/tools/Xilinx/Vivado/2020.1"

# already set in zcu102-zynqmp.conf
# PMU_FIRMWARE_DEPLOY_DIR = "${DEPLOY_DIR_IMAGE}"
# PMU_FIRMWARE_IMAGE_NAME = "pmu-firmware-${MACHINE}"

# Fix for Xilinx issue:
# https://github.com/Xilinx/meta-xilinx/pull/24
DEFAULTTUNE = "cortexa53"

# u-boot settings

# TODO(kd): Move these to their own machine
# SPL cannot be used by Zynqmp without some patches:
# https://xilinx-wiki.atlassian.net/wiki/spaces/A/pages/18842574/U-Boot+Secondary+Program+Loader
SPL_BINARY_${MACHINE} = ""

SOC_VARIANT = "cg"

IMAGE_INSTALL_append = " pmu-rom-qemu "

# entropy generator to make sure boot-up doesn't hang
IMAGE_INSTALL_append = " haveged "

EXTRA_IMAGEDEPENDS += " misc-task "

PREFERRED_PROVIDER_qemu-native = "qemu-xilinx-native"
PREFERRED_PROVIDER_nativesdk-qemu = "nativesdk-qemu-xilinx"

PREFERRED_PROVIDER_virtual/kernel = "linux-yocto"
PREFERRED_VERSION_virtual/kernel = "5.2"
# PREFERRED_PROVIDER_virtual/kernel = "linux-xlnx"

# PREFERRED_PROVIDER_virtual/bootloader = "u-boot-xlnx"
PREFERRED_PROVIDER_virtual/bootloader = "u-boot"

PREFERRED_PROVIDER_virtual/boot-bin = "xilinx-bootbin"

PMU_FIRMWARE_DEPLOY_DIR = "${DEPLOY_DIR_IMAGE}"
PMU_FIRMWARE_IMAGE_NAME = "pmu-firmware-${MACHINE}"

LICENSE_FLAGS_WHITELIST += " xilinx commercial "

YAML_SERIAL_CONSOLE_STDOUT = "psu_uart_0"
YAML_DT_BOARD_FLAGS = "{BOARD zcu102-reva}"

HDF_BASE = "file://"
HDF_PATH = "${KSD_XSA_DIR}/hardware_description.xsa"

BIF_FILE_PATH = "${KSD_TMP_CONF_DIR}/linux.bif"
BIF_PARTITION_ATTR_append = " bitstream "

# Don't use SPL with u-boot
SPL_BINARY = ""