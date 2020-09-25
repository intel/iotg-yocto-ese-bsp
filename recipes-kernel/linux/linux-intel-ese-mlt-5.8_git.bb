KERNEL_SRC_URI ?= "git://github.com/intel/mainline-tracking.git;protocol=https;nobranch=1;name=machine"
SRC_URI = "${KERNEL_SRC_URI}"
SRCREV_machine ?= "e4b7765bf5a290e6e241f1f2b9006f74af21b2ae"
LINUX_VERSION ?= "5.8"
LINUX_KERNEL_TYPE = "mainline-tracking"
KERNEL_PACKAGE_NAME = "${PN}-kernel"
require recipes-kernel/linux/linux-intel-ese.inc
LIC_FILES_CHKSUM = "file://COPYING;md5=6bc538ed5bd9a7fc9398086aedcd7e46"
# Optional kernel security harderning that may interfere with debugging
SRC_URI_append = " ${@bb.utils.contains('DISTRO_FEATURES', 'hardened', 'file://bsp/${BSP_SUBTYPE}/security.scc', '', d)}"
DEPENDS += "${@bb.utils.contains('DISTRO_FEATURES', 'hardened', 'openssl-native', '', d)}"
INHIBIT_PACKAGE_STRIP = "${@bb.utils.contains('DISTRO_FEATURES', 'hardened', '1', '0', d)}"

### overrides here
# Example:
#KERNEL_SRC_URI = "git://${TOPDIR}/../managed/linux-sources-mainline-5.4;name=machine;branch=HEAD;nobranch=1;protocol=file;usehead=1"
#SRCREV_machine = "${AUTOREV}"
#LINUX_VERSION  = "5.4-rc2"
