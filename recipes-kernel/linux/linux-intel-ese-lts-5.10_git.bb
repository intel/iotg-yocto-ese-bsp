require ./linux-intel-ese-lts-5.10.inc
require ./linux-intel-ese-lts.inc
require ./yocto-kernel-cache.inc
require ./linux-intel-ese.inc

KERNEL_SRC_URI = "git://github.com/sys-oak/linux-intel-restricted-adl-beta.git;protocol=ssh;branch=${KBRANCH};name=machine"
SRC_URI = "${KERNEL_SRC_URI}"

LINUX_VERSION_EXTENSION_append = "-lts"
KERNEL_PACKAGE_NAME = "${PN}-kernel"

#LTS2020 Specific feature configuration
SRC_URI_append = " file://bsp/${BSP_SUBTYPE}/ipmi.scc"

#Enable Audio for ADL-S/P on kernel 5.10
SRC_URI_append = " file://bsp/${BSP_SUBTYPE}/audio-adl.scc"

#Config for UDMABUF
SRC_URI_append = " file://bsp/${BSP_SUBTYPE}/udmabuf.scc"
