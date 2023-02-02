SUMMARY = "Intel Wireless LinuxCore kernel driver"
DESCRIPTION = "Intel Wireless LinuxCore kernel driver"
SECTION = "kernel"
LICENSE = "GPL-2.0-only"

REQUIRED_DISTRO_FEATURES = "wifi"

LIC_FILES_CHKSUM = "file://${S}/COPYING;md5=6bc538ed5bd9a7fc9398086aedcd7e46"

inherit module features_check

SRC_URI = "git://github.com/intel/backport-iwlwifi.git;nobranch=1;protocol=https \
           file://0001-Makefile.real-skip-host-install-scripts.patch \
           file://iwlwifi.conf \
          "

PV = "74-60+git${SRCPV}"
SRCREV = "1253d237296cc5469335c438571325216c629be3"

S = "${WORKDIR}/git/iwlwifi-stack-dev"

EXTRA_OEMAKE = "INSTALL_MOD_PATH=${D} KLIB_BUILD=${KBUILD_OUTPUT}"

MODULES_INSTALL_TARGET="install"

DEPENDS:append = " flex-native bison-native"

do_install:append() {
	## install configs and service scripts
	install -d ${D}${sysconfdir}/modprobe.d
	install -m 0644 ${WORKDIR}/iwlwifi.conf ${D}${sysconfdir}/modprobe.d
}

RDEPENDS:${PN} = "linux-firmware-iwlwifi"
### This breaks dependency resolution on external kernel modules like libarc4
# where instead of kernel-modules-libarc4, dnf searches for backport-iwlwifikernel-modules-libarc4
#KERNEL_MODULE_PACKAGE_PREFIX = "backport-iwlwifi"

# CLEANBROKEN doesn't quite work since it needs clean ups, yet make clean is actually broken
do_configure:append(){
	git checkout compat kconf
	# configure setup is broken and assumes only native build */
	oe_runmake defconfig-iwlwifi-public CC="${BUILD_CC}"
	# sed -i 's/CPTCFG_IWLMVM_VENDOR_CMDS=y/# CPTCFG_IWLMVM_VENDOR_CMDS is not set/' ${S}/.config
}
