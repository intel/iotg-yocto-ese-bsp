kernel_do_deploy_append(){
	mkdir -p "${DEPLOYDIR}/${KERNEL_PACKAGE_NAME}"
	cp "${B}/.config" "${DEPLOYDIR}/${KERNEL_PACKAGE_NAME}/${PN}-kernelsrc.config"
	tar -jcf "${DEPLOYDIR}/${KERNEL_PACKAGE_NAME}/${PN}-kernelsrc.tar.bz2" -C "${S}" --owner=root --group=root "--transform=s/^\./${PN}-kernelsrc/g" .
}
