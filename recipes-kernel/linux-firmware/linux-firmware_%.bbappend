# SRIOV support to use GuC 70.29.2

SRC_URI:append = " https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/i915/adlp_guc_70.bin?h=20240811;subdir=intel-linux-firmware;name=adlp_guc \
		   https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/i915/tgl_guc_70.bin?h=20240811;subdir=intel-linux-firmware;name=tgl_guc \
		 "
SRC_URI[adlp_guc.sha256sum] = "ea4b1b25b78e5442c142d6c7b27d0ecea25ff0cfb2272832f0e01c45e577215e"
SRC_URI[tgl_guc.sha256sum] = "bd94706ab560ec624a8461e834aff758bbb02021291783a5f125207b0ef8eb1e"

do_install:append () {
        install -m 644 ${WORKDIR}/intel-linux-firmware/tgl_guc_70.bin* ${D}${nonarch_base_libdir}/firmware/i915/tgl_guc_70.bin
        install -m 644 ${WORKDIR}/intel-linux-firmware/adlp_guc_70.bin* ${D}${nonarch_base_libdir}/firmware/i915/adlp_guc_70.bin
}
