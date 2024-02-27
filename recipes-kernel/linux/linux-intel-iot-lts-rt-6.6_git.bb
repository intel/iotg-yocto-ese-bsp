require ./linux-intel-iot-lts-rt-6.6.inc
require ./yocto-kernel-cache.inc
require ./linux-intel-ese.inc
require ./linux-intel-ese-lts.inc

LINUX_VERSION_EXTENSION:append = "-lts-rt"
KERNEL_PACKAGE_NAME = "${PN}-kernel"

# RT specific configuration
SRC_URI:append = " file://bsp/${BSP_SUBTYPE}/rt.cfg"

#Enable Audio for ADL-S/P on kernel 6.6
RC_URI:append = " file://bsp/${BSP_SUBTYPE}/audio-adl.scc"

# Optional kernel security harderning that may interfere with debugging
SRC_URI:append = " ${@bb.utils.contains('DISTRO_FEATURES', 'hardened', 'file://bsp/${BSP_SUBTYPE}/security.scc', '', d)}"
SRC_URI:append = " file://bsp/${BSP_SUBTYPE}/ipmi.scc"
DEPENDS += "${@bb.utils.contains('DISTRO_FEATURES', 'hardened', 'openssl-native', '', d)}"
INHIBIT_PACKAGE_STRIP = "${@bb.utils.contains('DISTRO_FEATURES', 'hardened', '1', '0', d)}"
