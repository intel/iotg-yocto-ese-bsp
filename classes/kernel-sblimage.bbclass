# slimboot image, based on iasimage
# unable to currently handle initrd SBLIMAGE_INITRD_PATH

# Slimboot auth format
SBLIMAGE_AUTH ?= ""

# path to deployed initrd
SBLIMAGE_INITRD_PATH ?= ""

# initrd recipe name
SBLIMAGE_DEPENDS ?= ""

# default container name
SBLIMAGE_BOOT_DEFAULT_CONTAINER ?= "sbl_os"

# Does loader support symlink?
SBLIMAGE_BOOT_SUPPORTS_SOFTLINK ?= "1"

inherit python3native
python do_sblimage_cmdline() {
  name = d.getVar('PN')
  # slimboot doesn't really do alternate menus, just try to guess based on ${PN}
  k_cmdline = d.getVarFlag('MENDER_GRUBCONF_KERNELS', name)
  default_cmdline = d.getVar('APPEND')
  extras_default = d.getVar('MENDER_GRUBCONF_KERNELS_DEFAULT')

  cmdline = "{0} {1}".format(default_cmdline, k_cmdline or extras_default or '')

  wd = d.getVar('WORKDIR')
  with open(os.path.join(wd, 'sbl_cmdline.txt'), 'w') as sbl_cmdline:
    sbl_cmdline.write(cmdline.strip())
}
do_sblimage_cmdline[vardeps] += "APPEND MENDER_GRUBCONF_KERNELS MENDER_GRUBCONF_KERNELS_DEFAULT"

fakeroot do_sblimage() {
	local auth
	if test -n "${SBLIMAGE_AUTH}"; then
		auth="-a ${SBLIMAGE_AUTH}"
	else
		auth=""
	fi
	${PYTHON} ${STAGING_DIR_NATIVE}/${libexecdir}/slimboot/Tools/GenContainer.py create -cl CMDL:${WORKDIR}/sbl_cmdline.txt \
		KRNL:${D}/${KERNEL_IMAGEDEST}/${KERNEL_IMAGETYPE}-${KERNEL_VERSION} INRD:${SBLIMAGE_INITRD_PATH} \
		-o ${WORKDIR}/slimboot/sbl_os \
		-k ${DEPLOY_DIR_IMAGE}/secure-boot-certificates-slimboot/SigningKey.pem -t CLASSIC \
		${auth}
	install -m 644 ${WORKDIR}/slimboot/sbl_os ${D}/${KERNEL_IMAGEDEST}/sbl_os-${KERNEL_VERSION_NAME}
	if test "${KERNEL_PACKAGE_NAME}" = "kernel"; then
		rm -f "${D}/${KERNEL_IMAGEDEST}/${SBLIMAGE_BOOT_DEFAULT_CONTAINER}"
		if test "${SBLIMAGE_BOOT_SUPPORTS_SOFTLINK}" != 0; then
			ln -s "sbl_os-${KERNEL_VERSION_NAME}" "${D}/${KERNEL_IMAGEDEST}/${SBLIMAGE_BOOT_DEFAULT_CONTAINER}"
		else
			install -m 644 ${WORKDIR}/slimboot/sbl_os "${D}/${KERNEL_IMAGEDEST}/${SBLIMAGE_BOOT_DEFAULT_CONTAINER}"
		fi
	fi
}

kernel_do_deploy:append() {
	install -m 0644 "${WORKDIR}/slimboot/sbl_os" "${DEPLOYDIR}/sbl_os-${KERNEL_VERSION_NAME}"
}

do_sblimage[cleandirs] += "${WORKDIR}/slimboot"
do_sblimage[fakeroot] = "1"
do_sblimage[umask] = "022"
do_sblimage[doc] = "Packs kernel commandline, image and initrd for slimboot OSLoader payload (GenContainer)"
do_sblimage[depends] += "virtual/secure-boot-certificates-slimboot:do_deploy slimboot-tools-native:do_populate_sysroot ${PYTHON_PN}-cryptography-native:do_populate_sysroot ${PYTHON_PN}-idna-native:do_populate_sysroot"
do_sblimage[recrdeptask] += "do_sblimage_cmdline"

addtask sblimage_cmdline
addtask sblimage after do_install before kernel_do_deploy
FILES:${KERNEL_PACKAGE_NAME}-image-sblimage = "/${KERNEL_IMAGEDEST}/${SBLIMAGE_BOOT_DEFAULT_CONTAINER} /${KERNEL_IMAGEDEST}/sbl_os-${KERNEL_VERSION_NAME}"
PACKAGES:append = " ${KERNEL_PACKAGE_NAME}-image-sblimage"

do_package[depends] += "${PN}:do_sblimage"
do_deploy[depends] += "${PN}:do_sblimage"

python(){
  deps = d.getVar('SBLIMAGE_DEPENDS')
  if deps:
    if deps.startswith('mc:'):
      depflag = 'mcdepends'
    else:
      depflag = 'depends'
    d.appendVarFlag('do_sblimage', depflag, ' ' + deps)
}
