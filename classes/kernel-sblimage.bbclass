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
fakeroot do_sblimage() {
	local auth
	echo "${APPEND}" > ${WORKDIR}/slimboot/sbl_cmdline.txt
	if test -n "${SBLIMAGE_AUTH}"; then
		auth="-a ${SBLIMAGE_AUTH}"
	else
		auth=""
	fi
	${PYTHON} ${STAGING_DIR_NATIVE}/${libexecdir}/slimboot/Tools/GenContainer.py create -cl CMDL:${WORKDIR}/slimboot/sbl_cmdline.txt \
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

kernel_do_deploy_append() {
	install -m 0644 "${WORKDIR}/slimboot/sbl_os" "${DEPLOYDIR}/sbl_os-${KERNEL_VERSION_NAME}"
}


do_sblimage[cleandirs] += "${WORKDIR}/slimboot"
do_sblimage[fakeroot] = "1"
do_sblimage[umask] = "022"
do_sblimage[doc] = "Packs kernel commandline, image and initrd for slimboot OSLoader payload (GenContainer)"
do_sblimage[depends] += "${PN}:do_install virtual/secure-boot-certificates-slimboot:do_deploy slimboot-tools-native:do_populate_sysroot ${PYTHON_PN}-cryptography-native:do_populate_sysroot ${PYTHON_PN}-idna-native:do_populate_sysroot"

addtask sblimage after do_install before kernel_do_deploy
FILES_${KERNEL_PACKAGE_NAME}-image-sblimage = "/${KERNEL_IMAGEDEST}/${SBLIMAGE_BOOT_DEFAULT_CONTAINER} /${KERNEL_IMAGEDEST}/sbl_os-${KERNEL_VERSION_NAME}"
PACKAGES_append = " ${KERNEL_PACKAGE_NAME}-image-sblimage"

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
