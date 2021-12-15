require ./linux-intel-iot-lts-rt-5.15.inc
require ./linux-intel-ese-lts.inc
require ./yocto-kernel-cache.inc
require ./linux-intel-ese.inc

LINUX_VERSION_EXTENSION:append = "-lts-rt"
KERNEL_PACKAGE_NAME = "${PN}-kernel"

# RT specific configuration
SRC_URI:append = " file://bsp/${BSP_SUBTYPE}/rt.cfg"
