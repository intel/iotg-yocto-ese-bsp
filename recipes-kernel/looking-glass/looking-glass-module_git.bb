DESCRIPTION = "Looking Glass is an open source application that allows the use of a KVM (Kernel-based Virtual Machine) configured for VGA PCI Pass-through without an attached physical monitor, keyboard or mouse."
HOMEPAGE = "https://looking-glass.hostfission.com"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://../LICENSE;md5=b234ee4d69f5fce4486a80fdaf4a4263"

SRC_URI = "git://github.com/gnif/LookingGlass.git;protocol=https;branch=Release/B1 \
           file://0001-Adding-dummy-modules_install.patch \
          "

SRCREV = "163a2e5d0a1168637da2524717b1328165c3c0b0"
S = "${WORKDIR}/git/module"

EXTRA_OEMAKE = 'KSRC="${STAGING_KERNEL_BUILDDIR}" KDIR="${STAGING_KERNEL_BUILDDIR}" KVER="${KERNEL_VERSION}" INSTALL_MOD_PATH="${D}"'

do_install_append() {
	install -d ${D}${nonarch_base_libdir}/modules/${KERNEL_VERSION}/update
	install -m 755 ${S}/*.ko ${D}${nonarch_base_libdir}/modules/${KERNEL_VERSION}/update/
}

inherit module
