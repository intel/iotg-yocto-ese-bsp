SUMMARY = "Intel Wireless LinuxCore kernel driver"
DESCRIPTION = "Intel Wireless LinuxCore kernel driver"
SECTION = "kernel"
LICENSE = "GPLv2"

REQUIRED_DISTRO_FEATURES = "wifi"

LIC_FILES_CHKSUM = "file://${S}/COPYING;md5=6bc538ed5bd9a7fc9398086aedcd7e46"

inherit module

SRC_URI = "git://github.com/intel/backport-iwlwifi.git;nobranch=1;protocol=https \
           file://0001-Makefile.real-skip-host-install-scripts.patch \
           file://iwlwifi.conf \
          "

PV = "54-58+git${SRCPV}"
SRCREV = "56592ade52343f274a9b3b9be54cab1c70c2fe90"

S = "${WORKDIR}/git/iwlwifi-stack-dev"

EXTRA_OEMAKE = "INSTALL_MOD_PATH=${D} KLIB_BUILD=${KBUILD_OUTPUT}"

MODULES_INSTALL_TARGET="install"

DEPENDS_append = " flex-native bison-native"

do_install_append() {
	## install configs and service scripts
	install -d ${D}${sysconfdir}/modprobe.d
	install -m 0644 ${WORKDIR}/iwlwifi.conf ${D}${sysconfdir}/modprobe.d
}

RDEPENDS_${PN} = "linux-firmware-iwlwifi"
### This breaks dependency resolution on external kernel modules like libarc4
# where instead of kernel-modules-libarc4, dnf searches for backport-iwlwifikernel-modules-libarc4
#KERNEL_MODULE_PACKAGE_PREFIX = "backport-iwlwifi"

# CLEANBROKEN doesn't quite work since it needs clean ups, yet make clean is actually broken
do_configure_append(){
	git checkout compat kconf
	oe_runmake defconfig-iwlwifi-public
	sed -i 's/CPTCFG_IWLMVM_VENDOR_CMDS=y/# CPTCFG_IWLMVM_VENDOR_CMDS is not set/' ${S}/.config
}
