SUMMARY = "Copy custom files to overlay"
DESCRIPTION = "Copy custom files to overlay"
LICENSE = "CLOSED"

# Specify files to pull in
# By default, Yocto will look in a directory called "files", which hello.txt is in
# https://www.yoctoproject.org/docs/2.5.1/ref-manual/ref-manual.html#var-SRC_URI
SRC_URI = "file://hello.txt"

do_install() {
    install -d ${D}${sysconfdir}

    install ${WORKDIR}/hello.txt ${D}${sysconfdir}
}