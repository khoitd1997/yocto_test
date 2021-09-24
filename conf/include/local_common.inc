require build_path.inc

# NOTE: Add extra Python import here
OE_EXTRA_IMPORTS_append = " math multiprocessing "

INHERIT += "buildhistory buildstats" 

MACHINE = "qemuarm64"

DISTRO = "poky"

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
PARALLEL_MAKE = "-j ${BB_NUMBER_THREADS}"

SSTATE_DIR = "${KSD_REPO_ROOT_DIR}/sstate"
SSTATE_MIRRORS = "file://.* file://${SSTATE_DIR}/PATH"

DL_DIR = "${KSD_REPO_ROOT_DIR}/dl"
BB_GENERATE_MIRROR_TARBALLS = "1"
CACHE = "${KSD_REPO_ROOT_DIR}/bitbake_cache"

IMAGE_FSTYPES = "ext4"
IMAGE_FSTYPES_remove = "tar.bz2"

EXTRA_IMAGE_FEATURES_remove = "ssh-server-dropbear"
