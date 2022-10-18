require ./linux-intel-ese-mlt.inc
require ./yocto-kernel-cache.inc
require ./linux-intel-ese.inc

KERNEL_SRC_URI = "git://github.com/intel/mainline-tracking.git;protocol=https;branch=${KBRANCH};name=machine"
SRCREV_machine = "1f98c591c3ed9f56a4f19235506717534ba87004"
LINUX_VERSION = "5.19.0"
LINUX_KERNEL_TYPE = "preempt-rt"
KBRANCH = "preempt-rt/v5.19-rt10"

LINUX_VERSION_EXTENSION:append = "-mainline-tracking-rt-519"
KERNEL_PACKAGE_NAME = "${PN}-kernel"

# Optional kernel security harderning that may interfere with debugging
SRC_URI:append = " ${@bb.utils.contains('DISTRO_FEATURES', 'hardened', 'file://bsp/${BSP_SUBTYPE}/security.scc', '', d)}"
SRC_URI:append = " file://bsp/${BSP_SUBTYPE}/ipmi.scc"
DEPENDS += "${@bb.utils.contains('DISTRO_FEATURES', 'hardened', 'openssl-native', '', d)}"
INHIBIT_PACKAGE_STRIP = "${@bb.utils.contains('DISTRO_FEATURES', 'hardened', '1', '0', d)}"
