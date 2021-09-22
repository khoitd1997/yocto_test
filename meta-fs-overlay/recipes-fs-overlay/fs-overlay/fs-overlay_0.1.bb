SUMMARY = "Copy custom files to overlay"
DESCRIPTION = "Copy custom files to overlay"
LICENSE = "MIT"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

do_install() {
    install -d ${D}${sysconfdir}

    install ${THISDIR}/files/hello.txt ${D}${sysconfdir}
}