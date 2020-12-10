KERNEL_SRC_URI ?= "git://github.com/intel/linux-intel-lts.git;protocol=https;branch=5.4/preempt-rt;name=machine"
SRC_URI = "${KERNEL_SRC_URI}"
SRCREV_machine ?= "cee47e7a1ca63213d933b52a3dcb5857d9020ee2"
LINUX_VERSION ?= "5.4.74"
LINUX_KERNEL_TYPE = "preempt-rt"
LINUX_VERSION_EXTENSION_append = "-lts-rt"
KERNEL_PACKAGE_NAME = "${PN}-kernel"

require recipes-kernel/linux/linux-intel-ese.inc

LIC_FILES_CHKSUM = "file://COPYING;md5=bbea815ee2795b2f4230826c0c6b8814"

# RT specific configuration
SRC_URI_append = " file://bsp/${BSP_SUBTYPE}/rt.cfg"

# Programmable Software Engine
SRC_URI_append = " file://ishtp-5.4.scc"

# io patches for 5.4
SRC_URI_append = " file://rt-io-5.4.scc"
