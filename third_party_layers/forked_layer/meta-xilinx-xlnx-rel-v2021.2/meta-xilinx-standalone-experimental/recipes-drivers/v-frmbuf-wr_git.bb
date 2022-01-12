inherit features_check

REQUIRED_DISTRO_FEATURES = "v-frmbuf-wr"

inherit esw python3native

DEPENDS += "xilstandalone video-common"

ESW_COMPONENT_SRC = "/XilinxProcessorIPLib/drivers/v_frmbuf_wr/src/"
ESW_COMPONENT_NAME = "libv_frmbuf_wr.a"

do_configure_prepend() {
    LOPPER_DTC_FLAGS="-b 0 -@" lopper.py ${DTS_FILE} -- baremetalconfig_xlnx.py ${ESW_MACHINE} ${S}/${ESW_COMPONENT_SRC}
    install -m 0755 *.cmake ${S}/${ESW_COMPONENT_SRC}/
    install -m 0755 xv_frmbufwr_g.c ${S}/${ESW_COMPONENT_SRC}/
}
