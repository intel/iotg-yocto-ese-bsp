# slimboot image, based on iasimage
# unable to currently handle initrd SBLIMAGE_INITRD_PATH
inherit python3native
fakeroot do_sblimage_sha256() {
	echo "${APPEND}" > ${WORKDIR}/slimboot_sha256/sbl_cmdline.txt
	${PYTHON} ${STAGING_DIR_NATIVE}/${libexecdir}/slimboot/Tools/GenContainer.py create -cl CMDL:${WORKDIR}/slimboot_sha256/sbl_cmdline.txt \
		KRNL:${D}/${KERNEL_IMAGEDEST}/${KERNEL_IMAGETYPE}-${KERNEL_VERSION} INRD:${SBLIMAGE_INITRD_PATH} \
		-o ${WORKDIR}/slimboot_sha256/${SBLIMAGE_NAME_sha256} \
		-k ${DEPLOY_DIR_IMAGE}/secure-boot-certificates-slimboot-2048/SigningKey.pem -t CLASSIC \
		-a RSA2048_PSS_SHA2_256
	install -m 644 ${WORKDIR}/slimboot_sha256/${SBLIMAGE_NAME_sha256} ${D}/${KERNEL_IMAGEDEST}/${SBLIMAGE_NAME_sha256}
	if test -f "${D}/${KERNEL_IMAGEDEST}/${DEFAULT_secure-boot-certificates-slimboot}" -a "${DEFAULT_secure-boot-certificates-slimboot}" = "${SBLIMAGE_NAME_sha256}"; then
		rm -f ${D}/${KERNEL_IMAGEDEST}/sbl_os
		ln -s "${DEFAULT_secure-boot-certificates-slimboot}" ${D}/${KERNEL_IMAGEDEST}/sbl_os
	fi
}

kernel_do_deploy_append() {
	install -m 0644 ${D}/${KERNEL_IMAGEDEST}/${SBLIMAGE_NAME_sha256} ${DEPLOYDIR}/${SBLIMAGE_NAME_sha256}
}

do_sblimage_sha256[doc] = "Packs kernel commandline, image and initrd for slimboot OSLoader payload (GenContainer)"
addtask sblimage_sha256 after do_install before kernel_do_deploy

DEPENDS += "slimboot-tools-native ${PYTHON_PN}-cryptography-native ${PYTHON_PN}-idna-native"
do_sblimage_sha256[depends] += "${PN}:do_install virtual/secure-boot-certificates-slimboot-2048:do_deploy"
do_package[depends] += "${PN}:do_sblimage_sha256"
do_deploy[depends] += "${PN}:do_sblimage_sha256"
do_sblimage_sha256[cleandirs] += "${WORKDIR}/slimboot_sha256"

SBLIMAGE_INITRD_PATH ?= ""
SBLIMAGE_DEPENDS ?= ""
BASE_SBLIMAGE_sha256 = "sbl_os_2k"
SBLIMAGE_NAME_sha256 = "${BASE_SBLIMAGE}"

python(){
    d.appendVar('PACKAGES', d.expand(' ${KERNEL_PACKAGE_NAME}-image-sblimage-sha256'))

    # fix host-user-contaminated QA warnings
    d.setVarFlag('do_sblimage_sha256', 'fakeroot', '1')
    d.setVarFlag('do_sblimage_sha256', 'umask', '022')

    name = d.getVar('KERNEL_PACKAGE_NAME')
    if name == 'kernel':
        sblname = d.expand("${BASE_SBLIMAGE_sha256}")
    else:
        sblname = d.expand('${BASE_SBLIMAGE_sha256}-${KERNEL_PACKAGE_NAME}')
    d.setVar('SBLIMAGE_NAME_sha256', sblname)

    files = d.expand("FILES_${KERNEL_PACKAGE_NAME}-image-sblimage-sha256")
    d.setVar(files, d.expand("/${KERNEL_IMAGEDEST}/${SBLIMAGE_NAME_sha256}"))
    defload = d.getVar('DEFAULT_secure-boot-certificates-slimboot')
    if defload == sblname:
      d.appendVar(files, ' ' + d.expand('${KERNEL_IMAGEDEST}/sbl_os'))

    deps = d.getVar('SBLIMAGE_DEPENDS')
    if deps:
        if deps.startswith('mc:'):
            depflag = 'mcdepends'
        else:
            depflag = 'depends'
        d.appendVarFlag('do_sblimage_sha256', depflag, ' ' + deps)
}
