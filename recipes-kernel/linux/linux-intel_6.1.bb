# stub recipe
require ./linux-intel-iot-lts-6.1.inc
require ./linux-intel-ese-lts.inc
require ./yocto-kernel-cache.inc
require recipes-kernel/linux/linux-yocto.inc
require recipes-kernel/linux/meta-intel-compat-kernel.inc

FILESEXTRAPATHS:prepend := "${THISDIR}/linux-intel:"

########## copied from meta-intel
DEPENDS += "elfutils-native openssl-native util-linux-native"

SRC_URI:append = " file://0001-vt-conmakehash-improve-reproducibility.patch \
                   file://0001-lib-build_OID_registry-fix-reproducibility-issues.patch \
                   file://fix-perf-reproducibility.patch \
                   file://0001-v6.1-menuconfig-mconf-cfg-Allow-specification-of-ncurses-.patch \
	         "

PV = "${LINUX_VERSION}+git${SRCPV}"

KCONF_BSP_AUDIT_LEVEL = "2"

KERNEL_FEATURES:append = " ${KERNEL_EXTRA_FEATURES}"

# Functionality flags
KERNEL_EXTRA_FEATURES ?= "features/netfilter/netfilter.scc features/security/security.scc"

UPSTREAM_CHECK_GITTAGREGEX = "^lts-(?P<pver>v6.1.(\d+)-linux-(\d+)T(\d+)Z)$"
