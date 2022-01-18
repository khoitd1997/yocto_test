require build_path.inc

# NOTE: Add extra Python import here
OE_EXTRA_IMPORTS_append = " math multiprocessing "

INHERIT += "buildhistory buildstats" 

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