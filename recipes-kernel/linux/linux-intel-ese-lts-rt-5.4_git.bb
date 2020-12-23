require ./linux-intel-ese-lts-rt-5.4.inc
require ./linux-intel-ese-lts.inc
require ./yocto-kernel-cache.inc
require ./linux-intel-ese.inc

LINUX_VERSION_EXTENSION_append = "-lts-rt"
KERNEL_PACKAGE_NAME = "${PN}-kernel"

# RT specific configuration
SRC_URI_append = " file://bsp/${BSP_SUBTYPE}/rt.cfg"

# Programmable Software Engine
SRC_URI_append = " file://ishtp-5.4.scc"

# io patches for 5.4
SRC_URI_append = " file://rt-io-5.4.scc"
