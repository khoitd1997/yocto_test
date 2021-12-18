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

IMAGE_FSTYPES = "ext4"
IMAGE_FSTYPES_remove = "tar.bz2"

EXTRA_IMAGE_FEATURES_remove = "ssh-server-dropbear"

# KERNEL_FEATURES_append = "features/test_features/test.scc"

# KCONFIG_CONFIG_COMMAND = "xconfig"

XILINX_VER_MAIN = "2020.1"
XILINX_VIVADO_DESIGN_SUIT = "/tools/Xilinx/Vivado/2020.1"

# already set in zcu102-zynqmp.conf
# PMU_FIRMWARE_DEPLOY_DIR = "${DEPLOY_DIR_IMAGE}"
# PMU_FIRMWARE_IMAGE_NAME = "pmu-firmware-${MACHINE}"

# Fix for Xilinx issue:
# https://github.com/Xilinx/meta-xilinx/pull/24
DEFAULTTUNE = "cortexa53"

# u-boot settings

# UBOOT_CONFIG # this is the defconfig name as well as the IMAGE_FSTYPES

# TODO(kd): Move these to their own machine
# SPL cannot be used by Zynqmp without some patches:
# https://xilinx-wiki.atlassian.net/wiki/spaces/A/pages/18842574/U-Boot+Secondary+Program+Loader
SPL_BINARY_${MACHINE} = ""

SOC_VARIANT = "cg"

IMAGE_INSTALL_append = " pmu-rom-qemu "

PREFERRED_PROVIDER_qemu-native = "qemu-xilinx-native"
PREFERRED_PROVIDER_nativesdk-qemu = "nativesdk-qemu-xilinx"

PREFERRED_PROVIDER_virtual/kernel = "linux-xlnx"
PREFERRED_PROVIDER_virtual/bootloader = "u-boot-xlnx"
PREFERRED_PROVIDER_virtual/boot-bin = "xilinx-bootbin"

PMU_FIRMWARE_DEPLOY_DIR = "${DEPLOY_DIR_IMAGE}"
PMU_FIRMWARE_IMAGE_NAME = "pmu-firmware-${MACHINE}"

LICENSE_FLAGS_WHITELIST += " xilinx commercial "

YAML_SERIAL_CONSOLE_STDOUT = "psu_uart_0"
YAML_DT_BOARD_FLAGS = "{BOARD zcu102-reva}"

HDF_BASE = "file://"
HDF_PATH = "${KSD_XSA_DIR}/hardware_description.xsa"

IMAGE_BOOT_FILES_remove = "${KERNEL_IMAGETYPE}-zynqmp-zcu102-rev1.0.dtb"
IMAGE_BOOT_FILES_append = " ${MACHINE}-system.dtb"

# /home/kd/yocto_test/poky/build/zcu102-zynqmp-petalinux-debug/tmp/work/x86_64-linux/qemu-xilinx-helper-native/1.0-r1/recipe-sysroot-native/usr/bin/qemu-system-microblazeel 
# -M microblaze-fdt -display none -hw-dtb 
# /home/kd/yocto_test/poky/build/zcu102-zynqmp-petalinux-debug/tmp/deploy/images/zcu102-zynqmp/qemu-hw-devicetrees/multiarch/zynqmp-pmu.dtb 
# -kernel /home/kd/yocto_test/poky/build/zcu102-zynqmp-petalinux-debug/tmp/deploy/images/zcu102-zynqmp/pmu-rom.elf 
# -device loader,file=/home/kd/yocto_test/poky/build/tmp/deploy/images/zcu102-zynqmp/pmu-zcu102-zynqmp.elf -device loader,addr=0xfd1a0074,data=0x1011003,data-len=4 -device loader,addr=0xfd1a007C,data=0x1010f03,data-len=4 -machine-path /tmp/tmpy32_j2la

# home/kd/yocto_test/poky/build/zcu102-zynqmp-petalinux-debug/tmp/work/x86_64-linux/qemu-xilinx-helper-native/1.0-r1/recipe-sysroot-native/usr/bin/qemu-system-aarch64 -net nic -net nic -net nic -net nic,netdev=net0,macaddr=52:54:00:12:35:02 -netdev user,id=net0,hostfwd=tcp::2222-:22,hostfwd=tcp::2323-:23,tftp=/home/kd/yocto_test/poky/build/zcu102-zynqmp-petalinux-debug/tmp/deploy/images/zcu102-zynqmp -drive if=sd,index=1,file=/home/kd/yocto_test/poky/build/zcu102-zynqmp-petalinux-debug/tmp/deploy/images/zcu102-zynqmp/petalinux-image-minimal-zcu102-zynqmp.ext4,format=raw -nographic -serial mon:stdio -serial null -hw-dtb /home/kd/yocto_test/poky/build/zcu102-zynqmp-petalinux-debug/tmp/deploy/images/zcu102-zynqmp/qemu-hw-devicetrees/multiarch/zcu102-arm.dtb -global xlnx,zynqmp-boot.cpu-num=0 -global xlnx,zynqmp-boot.use-pmufw=true -device loader,file=/home/kd/yocto_test/poky/build/zcu102-zynqmp-petalinux-debug/tmp/deploy/images/zcu102-zynqmp/arm-trusted-firmware.elf,cpu-num=0 -device loader,file=/home/kd/yocto_test/poky/build/zcu102-zynqmp-petalinux-debug/tmp/deploy/images/zcu102-zynqmp/u-boot.elf -device loader,file=/home/kd/yocto_test/poky/build/zcu102-zynqmp-petalinux-debug/tmp/deploy/images/zcu102-zynqmp/system.dtb,addr=0x100000 -boot mode=5 -nographic -machine arm-generic-fdt -m 4096 -machine-path /tmp/tmpps56lssg