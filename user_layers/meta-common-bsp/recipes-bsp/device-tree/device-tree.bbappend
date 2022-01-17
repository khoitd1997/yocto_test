# Xilinx uses /include/ instead of #include for some reasons for EXTRA_OVERLAYS
# this doesn't cause the file not to be included but it does cause the content of the file
# to not be in the preprocessed file, which is annoying when debugging
do_configure_append () {
    sed -i 's|/include/|#include|' ${DT_FILES_PATH}/${BASE_DTS}.dts
}

do_deploy_append() {
    # also install all preprocessed files
    for DTS_PP_FILE in `ls *.dts.pp `; do
        install -Dm 0644 ${B}/${DTS_PP_FILE} ${DEPLOYDIR}/devicetree/${DTS_PP_FILE}
    done
}