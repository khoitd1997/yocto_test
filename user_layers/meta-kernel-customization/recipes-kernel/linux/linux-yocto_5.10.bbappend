FILESEXTRAPATHS_append := "${THISDIR}:"

SRC_URI_append = " \
        file://test_platform;type=kmeta;destsuffix=test_platform \
        "