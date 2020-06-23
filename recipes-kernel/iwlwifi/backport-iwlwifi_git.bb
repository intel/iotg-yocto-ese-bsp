SUMMARY = "Intel Wireless LinuxCore kernel driver"
DESCRIPTION = "Intel Wireless LinuxCore kernel driver"
SECTION = "kernel"
LICENSE = "GPLv2"

REQUIRED_DISTRO_FEATURES = "wifi"

LIC_FILES_CHKSUM = "file://${S}/COPYING;md5=bbea815ee2795b2f4230826c0c6b8814"

inherit module

SRC_URI = "git://github.com/intel/backport-iwlwifi.git;nobranch=1;protocol=https \
           file://0001-Makefile.real-skip-host-install-scripts.patch \
           file://iwlwifi.conf \
          "

PV = "52-54+git${SRCPV}"
SRCREV = "7b117a3692752c32821f4ffc921685127a6cd89a"

S = "${WORKDIR}/git/iwlwifi-stack-dev"

EXTRA_OEMAKE = "defconfig-iwlwifi-public INSTALL_MOD_PATH=${D} KLIB_BUILD=${KBUILD_OUTPUT}"

do_compile_prepend() {
	oe_runmake defconfig-iwlwifi-public
	sed -i 's/CPTCFG_IWLMVM_VENDOR_CMDS=y/# CPTCFG_IWLMVM_VENDOR_CMDS is not set/' ${S}/.config
}

MODULES_INSTALL_TARGET="install"

do_install_append() {
	## install configs and service scripts
	install -d ${D}${sysconfdir}/modprobe.d
	install -m 0644 ${WORKDIR}/iwlwifi.conf ${D}${sysconfdir}/modprobe.d
}

RDEPENDS_${PN} = "linux-firmware-iwlwifi"
### This breaks dependency resolution on external kernel modules like libarc4
# where instead of kernel-modules-libarc4, dnf searches for backport-iwlwifikernel-modules-libarc4
#KERNEL_MODULE_PACKAGE_PREFIX = "backport-iwlwifi"
CLEANBROKEN = "1"
