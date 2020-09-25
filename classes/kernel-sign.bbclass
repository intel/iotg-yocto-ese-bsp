kernel_do_install_append() {
	sbsign --key "${DEPLOY_DIR_IMAGE}/secure-boot-certificates/yocto.key" --cert "${DEPLOY_DIR_IMAGE}/secure-boot-certificates/yocto.crt" \
		--output "${D}/${KERNEL_IMAGEDEST}/${KERNEL_IMAGETYPE}-${KERNEL_PACKAGE_NAME}" "${D}/${KERNEL_IMAGEDEST}/${KERNEL_IMAGETYPE}-${KERNEL_VERSION}"
}

do_install[depends] += "virtual/secure-boot-certificates:do_deploy"
DEPENDS += "sbsigntool-native"

python(){
    d.appendVar('PACKAGES', ' ' + d.getVar('KERNEL_PACKAGE_NAME') + '-image-signed')
    d.setVar(d.expand("FILES_${KERNEL_PACKAGE_NAME}-image-signed"), d.expand("/${KERNEL_IMAGEDEST}/${KERNEL_IMAGETYPE}-${KERNEL_PACKAGE_NAME}"))
}

kernel_do_deploy_append() {
        install -m 0644 ${D}/${KERNEL_IMAGEDEST}/${KERNEL_IMAGETYPE}-${KERNEL_PACKAGE_NAME} ${DEPLOYDIR}/${KERNEL_IMAGETYPE}-${KERNEL_PACKAGE_NAME}.signed
}
