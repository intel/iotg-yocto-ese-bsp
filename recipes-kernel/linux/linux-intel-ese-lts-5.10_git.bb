require ./linux-intel-ese-lts-5.10.inc
require ./linux-intel-ese-lts.inc
require ./yocto-kernel-cache.inc
require ./linux-intel-ese.inc

LINUX_VERSION_EXTENSION:append = "-lts"
KERNEL_PACKAGE_NAME = "${PN}-kernel"

#LTS2020 Specific feature configuration
SRC_URI:append = " file://bsp/${BSP_SUBTYPE}/ipmi.scc"

#Enable Audio for ADL-S/P on kernel 5.10
SRC_URI:append = " file://bsp/${BSP_SUBTYPE}/audio-adl.scc"
