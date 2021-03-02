KERNEL_SRC_URI ?= "git://github.com/intel/linux-intel-lts.git;protocol=https;branch=5.4/preempt-rt;name=machine"
SRC_URI = "${KERNEL_SRC_URI}"
SRCREV_machine ?= "e00ce2dbe204df8675b04a820f6a4e6fc0f784b1"
LINUX_VERSION ?= "5.4.61"
LINUX_KERNEL_TYPE = "preempt-rt"
KERNEL_PACKAGE_NAME = "${PN}-kernel"

require recipes-kernel/linux/linux-intel-ese.inc

LIC_FILES_CHKSUM = "file://COPYING;md5=bbea815ee2795b2f4230826c0c6b8814"

# RT specific configuration
SRC_URI_append = " file://bsp/${BSP_SUBTYPE}/rt.cfg"

# Programmable Software Engine
SRC_URI_append = " file://ishtp-5.4.scc"

# Ethernet patches for 5.4
SRC_URI_append = " file://rt-ethernet-5.4.scc"

# io patches for 5.4
SRC_URI_append = " file://rt-io-5.4.scc"

# audio patches for 5.4
SRC_URI_append = " file://rt-audio-5.4.scc"
