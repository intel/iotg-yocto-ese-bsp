KERNEL_SRC_URI ?= "git://github.com/intel/linux-intel-lts.git;protocol=https;branch=5.4/preempt-rt;name=machine"
SRC_URI = "${KERNEL_SRC_URI}"
SRCREV_machine ?= "6f0f7e5dd27c1798d0d58ccdf3cccebf79aef8a0"
LINUX_VERSION ?= "5.4.70-rt40"
LINUX_KERNEL_TYPE = "preempt-rt"
KERNEL_PACKAGE_NAME = "${PN}-kernel"

require recipes-kernel/linux/linux-intel-ese.inc

LIC_FILES_CHKSUM = "file://COPYING;md5=bbea815ee2795b2f4230826c0c6b8814"

# RT specific configuration
SRC_URI_append = " file://bsp/${BSP_SUBTYPE}/rt.cfg"

# Programmable Software Engine
SRC_URI_append = " file://ishtp-5.4.scc"

# io patches for 5.4
SRC_URI_append = " file://rt-io-5.4.scc"
