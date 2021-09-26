# TODO: Take another look at structuring config files:
# https://stackoverflow.com/questions/55297773/using-require-in-layer-conf-in-yocto

# NOTE: a require in one file is enough
# for example, bblayers.conf can require a.conf
# and local.conf won't have to require that file again

# NOTE: Custom variables are prefixed with string "KSD" to avoid
# overwriting other variables

KSD_REPO_ROOT_DIR = "${TOPDIR}/../.."

KSD_USER_LAYERS_DIR = "${KSD_REPO_ROOT_DIR}/user_layers"
KSD_THIRD_PARTY_LAYERS_DIR = "${KSD_REPO_ROOT_DIR}/third_party_layers"

KSD_CACHE_DIR = "${KSD_REPO_ROOT_DIR}/cache"

KSD_CONF_DIR = "${KSD_REPO_ROOT_DIR}/conf"
KSD_KERNEL_CONF_DIR = "${KSD_CONF_DIR}/kernel"

KSD_META_OPENEMBEDDED_DIR = "${KSD_THIRD_PARTY_LAYERS_DIR}/meta-openembedded"
KSD_POKY_DIR = "${TOPDIR}/.."