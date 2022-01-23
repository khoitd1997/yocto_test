require build_path.inc
require build_infra.inc

# the local.conf of individual build config should set these variables
# this is just a placeholder
KSD_BUILD_NAME ?= "defaultname"

# MACHINE = "qemuarm64"
# MACHINE = "zcu102-zynqmp"
# MACHINE = "my-zcu102-zynqmp"
MACHINE = "my-ultra96-zynqmp"
# MACHINE = "ultra96-zynqmp"
# MACHINE = "qemuzynq"
# MACHINE = "zynqmp-generic"

DISTRO = "my-distro"
# DISTRO = "poky"

PACKAGE_CLASSES ?= "package_ipk"

SDKMACHINE = "x86_64"
# SDKMACHINE = "x86_64-mingw32"

USER_CLASSES_append = "buildstats image-mklibs image-prelink"

PATCHRESOLVE = "noop"

CONF_VERSION = "1"

EXTRA_IMAGE_FEATURES_remove = "ssh-server-dropbear"

KERNEL_FEATURES_append = " features/test_features/test.scc "
KERNEL_FEATURES_append_my-ultra96-zynqmp = " \
                            cfg/zynqmp_remoteproc.scc \
"

# set empty here so that xsct isn't downloaded from remote
# based on observations from xsct-tarball.bbclass
# NOTE: Vitis installation is actually required for the bitstream steps
# so might as well not download another copy of xsct
XSCT_TARGETS = ""

# NOTE: Seems like tools are added to PATH using vivado.bbclass
XILINX_VER_MAIN = "2021.2"
XILINX_VIVADO_DESIGN_SUIT = "/tools/Xilinx/Vivado/${XILINX_VER_MAIN}"
XILINX_SDK_TOOLCHAIN = "/tools/Xilinx/Vitis/${XILINX_VER_MAIN}"

# haveged seems to have problems with postinstall script for systemd
# IMAGE_INSTALL_append = " haveged "

EXTRA_IMAGEDEPENDS += " misc-task "

LICENSE_FLAGS_WHITELIST += " xilinx commercial "

HDF_BASE = "file://"
# HDF_PATH_my-ultra96-zynqmp = "${KSD_XSA_DIR}/ULTRA96V2.xsa"
# custom xsa
# HDF_PATH_my-ultra96-zynqmp = "${KSD_XSA_DIR}/ULTRA96V2_wrapper.xsa"
HDF_PATH_my-ultra96-zynqmp = "${KSD_XSA_DIR}/design_1_wrapper.xsa"
# HDF_PATH_ultra96-zynqmp = "${KSD_XSA_DIR}/ULTRA96V2_wrapper.xsa"
HDF_PATH_my-zcu102-zynqmp = "${KSD_XSA_DIR}/zcu102_2021_2.xsa"

# for using init instead of systemd
# DISTRO_FEATURES_append = " sysvinit "

DISTRO_FEATURES_append = " zeroconf systemd usbhost "
# need this to specify that only systemd should be used, otw, sysvinit is also used
VIRTUAL-RUNTIME_init_manager = "systemd"

IMAGE_INSTALL_append = " udev "

TOOLCHAIN_HOST_TASK_append = " nativesdk-python3 nativesdk-ccache"