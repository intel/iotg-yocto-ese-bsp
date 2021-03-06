require ./linux-intel-ese-lts-5.4.inc
require ./linux-intel-ese-lts.inc
require ./yocto-kernel-cache.inc
require ./linux-intel-ese.inc

LINUX_VERSION_EXTENSION_append = "-lts"
KERNEL_PACKAGE_NAME = "${PN}-kernel"

# Programmable Software Engine
SRC_URI_append = " file://ishtp-5.4.scc"

# xdp or libbpf patches
SRC_URI_append = " file://libbpf-5.4.scc"

# TGPIO
SRC_URI_append = " file://tgpio-5.4.scc"

# IGC / GBE
SRC_URI_append = " file://ethernet-5.4.scc"
