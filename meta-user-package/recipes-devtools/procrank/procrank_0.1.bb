SUMMARY = "Memory analysis tools"
DESCRIPTION = "Procrank is a tool commonly used by Android platform developers to find out how much memory is really being used. This recipe is a port to Linux from Android"
HOMEPAGE = "https://github.com/csimmonds/procrank_linux"
SECTION = "devel"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://NOTICE;md5=9645f39e9db895a4aa6e02cb57294595"

SRC_URI = "git://github.com/csimmonds/procrank_linux.git"
SRCREV = "5aa6840b617ab2052c365c26b32ebc5fa96ad657"

DEPENDS = "virtual/libc"

EXTRA_OEMAKE = " CROSS_COMPILE=${TARGET_PREFIX} "

S = "${WORKDIR}/git"

do_compile() {
    oe_runmake
}

do_install() {
    oe_runmake install DESTDIR=${D}
}

