require ./linux-intel-ese-mlt.inc
require ./yocto-kernel-cache.inc
require ./linux-intel-ese.inc

KERNEL_SRC_URI = "git://github.com/intel/mainline-tracking.git;protocol=https;branch=${KBRANCH};name=machine"
SRCREV_machine = "794635f43e0b4ec848e49d46e5b5717307ee4908"
LINUX_VERSION = "5.17-rc3"
KBRANCH = "linux/v5.17-rc3"

LINUX_VERSION_EXTENSION:append = "-mainline-tracking-517"
KERNEL_PACKAGE_NAME = "${PN}-kernel"

# Optional kernel security harderning that may interfere with debugging
SRC_URI:append = " ${@bb.utils.contains('DISTRO_FEATURES', 'hardened', 'file://bsp/${BSP_SUBTYPE}/security.scc', '', d)}"
SRC_URI:append = " file://bsp/${BSP_SUBTYPE}/ipmi.scc"
DEPENDS += "${@bb.utils.contains('DISTRO_FEATURES', 'hardened', 'openssl-native', '', d)}"
INHIBIT_PACKAGE_STRIP = "${@bb.utils.contains('DISTRO_FEATURES', 'hardened', '1', '0', d)}"
