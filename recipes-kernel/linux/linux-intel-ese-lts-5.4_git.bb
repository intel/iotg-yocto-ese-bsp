KERNEL_SRC_URI ?= "git://github.com/intel/linux-intel-lts.git;protocol=https;branch=5.4/yocto;name=machine"
SRC_URI = "${KERNEL_SRC_URI}"
SRCREV_machine ?= "6461d5d288f2c9f03a4f44b784003b4ac25ec5e1"
LINUX_VERSION ?= "5.4.72"
LINUX_KERNEL_TYPE = "lts"
KERNEL_PACKAGE_NAME = "${PN}-kernel"

require recipes-kernel/linux/linux-intel-ese.inc

LIC_FILES_CHKSUM = "file://COPYING;md5=bbea815ee2795b2f4230826c0c6b8814"

# Optional kernel security harderning that may interfere with debugging
SRC_URI_append = " ${@bb.utils.contains('DISTRO_FEATURES', 'hardened', 'file://bsp/${BSP_SUBTYPE}/security.scc', '', d)}"
DEPENDS += "${@bb.utils.contains('DISTRO_FEATURES', 'hardened', 'openssl-native', '', d)}"
INHIBIT_PACKAGE_STRIP = "${@bb.utils.contains('DISTRO_FEATURES', 'hardened', '1', '0', d)}"

# Programmable Software Engine
SRC_URI_append = " file://ishtp-5.4.scc"

# IO patches
SRC_URI_append = " file://io-5.4.scc"

# xdp or libbpf patches
SRC_URI_append = " file://libbpf-5.4.scc"

# Graphics patch
SRC_URI_append = " file://gfx-5.4.scc"
