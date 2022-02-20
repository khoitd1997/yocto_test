SUMMARY = "Copy custom files to overlay"
DESCRIPTION = "Copy custom files to overlay"
LICENSE = "CLOSED"

# Specify files to pull in
# By default, Yocto will look in a directory called "files", which flash_r5.sh is in
# https://www.yoctoproject.org/docs/2.5.1/ref-manual/ref-manual.html#var-SRC_URI
SRC_URI = "\
        file://flash_r5.sh \
        file://openssh_keys/ssh_host_ecdsa_key \
        file://openssh_keys/ssh_host_ed25519_key \
        file://openssh_keys/ssh_host_rsa_key \
        file://openssh_keys/ssh_host_ecdsa_key.pub \
        file://openssh_keys/ssh_host_ed25519_key.pub \
        file://openssh_keys/ssh_host_rsa_key.pub \
"

do_install() {
    install -d ${D}${bindir}
    install -m 0755 ${WORKDIR}/flash_r5.sh ${D}${bindir}

    ssh_conf_dir="${D}${sysconfdir}/ssh"
    install -d "${ssh_conf_dir}"
    install -m 0600 ${WORKDIR}/openssh_keys/* "${ssh_conf_dir}"
    chmod 0644 ${WORKDIR}/openssh_keys/*.pub
    chmod 0700 "${ssh_conf_dir}"
}

FILES_${PN} += "\
        ${bindir}/flash_r5.sh \
        ${sysconfdir}/ssh/ssh_host_ecdsa_key \
        ${sysconfdir}/ssh/ssh_host_ed25519_key \
        ${sysconfdir}/ssh/ssh_host_rsa_key \
        ${sysconfdir}/ssh/ssh_host_ecdsa_key.pub \
        ${sysconfdir}/ssh/ssh_host_ed25519_key.pub \
        ${sysconfdir}/ssh/ssh_host_rsa_key.pub \
"