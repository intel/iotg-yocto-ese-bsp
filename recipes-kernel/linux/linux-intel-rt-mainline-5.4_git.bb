KERNEL_SRC_URI ?= "git://github.com/github.com/intel/linux-intel-lts.git;protocol=https;nobranch=1;name=machine"
SRC_URI = "${KERNEL_SRC_URI}"
# tip of refs/heads/preempt-rt
SRCREV_machine ?= "b7a2b74892fe1341ddb5940104a1a4d4f8571be2"
LINUX_VERSION ?= "5.4.3"
LINUX_KERNEL_TYPE = "preempt-rt"
KERNEL_PACKAGE_NAME = "${PN}-kernel"

require recipes-kernel/linux/linux-intel-ese.inc

LIC_FILES_CHKSUM = "file://COPYING;md5=bbea815ee2795b2f4230826c0c6b8814"

# RT specific configuration
SRC_URI_append = " file://bsp/${BSP_SUBTYPE}/rt.cfg"
