inherit terminal

OE_TERMINAL_EXPORTS += "HOST_EXTRACFLAGS HOSTLDFLAGS TERMINFO PKG_CONFIG_PATH PKG_CONFIG_SYSROOT_DIR "
TERMINFO = "${STAGING_DATADIR_NATIVE}/terminfo"

# have to use host qt5 since the qt5-native package doesn't have enough dependency
PKG_CONFIG_PATH = "/usr/lib/x86_64-linux-gnu/pkgconfig"
HOST_EXTRACFLAGS = "${BUILD_CFLAGS} ${BUILD_LDFLAGS}"
HOSTLDFLAGS = "${BUILD_LDFLAGS}"
# per documentation in https://linux.die.net/man/1/pkg-config
# include path, etc will be prefixed with PKG_CONFIG_SYSROOT_DIR
# which is not what we want when building for host
PKG_CONFIG_SYSROOT_DIR = ""

KCONFIG_XCONFIG_ROOTDIR ??= "${B}"

python do_xconfig() {
    import shutil

    config = os.path.join(d.getVar('KCONFIG_XCONFIG_ROOTDIR'), ".config")
    configorig = os.path.join(d.getVar('KCONFIG_XCONFIG_ROOTDIR'), ".config.orig")

    try:
        mtime = os.path.getmtime(config)
        shutil.copy(config, configorig)
    except OSError:
        mtime = 0

    import subprocess

    oe_terminal("sh -c \"pkg-config --debug --cflags Qt5Core; make %s; if [ \\$? -ne 0 ]; then echo 'Command failed.'; printf 'Press any key to continue... '; read r; fi\"" % "xconfig",
                d.getVar('PN') + ' Configuration', d)

    # FIXME this check can be removed when the minimum bitbake version has been bumped
    if hasattr(bb.build, 'write_taint'):
        try:
            newmtime = os.path.getmtime(config)
        except OSError:
            newmtime = 0

        if newmtime > mtime:
            bb.note("Configuration changed, recompile will be forced")
            bb.build.write_taint('do_compile', d)
}
do_xconfig[nostamp] = "1"
do_xconfig[dirs] = "${KCONFIG_XCONFIG_ROOTDIR}"

addtask xconfig after do_configure
