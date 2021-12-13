kernel_do_deploy:append(){
	mkdir -p "${DEPLOYDIR}/${KERNEL_PACKAGE_NAME}"
	cp "${B}/.config" "${DEPLOYDIR}/${KERNEL_PACKAGE_NAME}/${PN}-kernelsrc.config"
	tar -jcf "${DEPLOYDIR}/${KERNEL_PACKAGE_NAME}/${PN}-kernelsrc.tar.bz2" -C "$(dirname ${S})" --owner=root --group=root ./"$(basename ${S})"
}
