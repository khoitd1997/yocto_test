do_copy_sdk() {
    rm -rf "${KSD_TOOLCHAIN_DIR}"
    mkdir -p "${KSD_TOOLCHAIN_DIR}"
    cp -r "${SDK_DEPLOY}" "${KSD_TOOLCHAIN_DIR}"
}
addtask do_copy_sdk after do_populate_sdk before do_build
do_copy_sdk[depends] += "${PN}:do_populate_sdk"
do_copy_sdk[vardeps] += "KSD_TOOLCHAIN_DIR"
do_copy_sdk[vardeps] += "SDK_DEPLOY"

do_build[depends] += "${PN}:do_copy_sdk"