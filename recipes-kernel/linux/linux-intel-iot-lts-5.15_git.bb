require ./linux-intel-iot-lts-5.15.inc
require ./linux-intel-ese-lts.inc
require ./yocto-kernel-cache.inc
require ./linux-intel-ese.inc

LINUX_VERSION_EXTENSION:append = "-lts"
KERNEL_PACKAGE_NAME = "${PN}-kernel"

#LTS2021 feature configuration
SRC_URI:append = " file://bsp/${BSP_SUBTYPE}/ipmi.scc"

#Enable Audio for ADL-S/P on 5.15 kernel
SRC_URI:append = " file://bsp/${BSP_SUBTYPE}/audio-adl.scc"
