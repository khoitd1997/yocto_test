# TODO: Take another look at structuring config files:
# https://stackoverflow.com/questions/55297773/using-require-in-layer-conf-in-yocto

# NOTE: a require in one file is enough
# for example, bblayers.conf can require a.conf
# and local.conf won't have to require that file again

# NOTE: Custom variables are prefixed with string "KD" to avoid
# overwriting other variables

KD_REPO_ROOT_DIR = "${TOPDIR}/../.."

KD_META_OPENEMBEDDED_DIR = "${KD_REPO_ROOT_DIR}/meta-openembedded"
KD_POKY_DIR = "${TOPDIR}/.."