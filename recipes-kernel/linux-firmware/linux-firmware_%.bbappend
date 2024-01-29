# PSIRT: PTK0003132 GuC Firmware is required to solve the vulnerability issue

SRC_URI:append = " https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/i915/adlp_guc_70.bin?h=20231211;subdir=intel-linux-firmware;name=adlp_guc \
		   https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/i915/tgl_guc_70.bin?h=20231211;subdir=intel-linux-firmware;name=tgl_guc \
		 "
SRC_URI[adlp_guc.sha256sum] = "6efd9cc10185c07a7e934ce3aa670f4a40739bba3c9d5124b1c8c9a2b026d6ce"
SRC_URI[tgl_guc.sha256sum] = "2ad3d8796b759f823e4c76c5f8614452010cbb0e0ef3b90931cb3a809d08d631"

do_install:append () {
        install -m 644 ${WORKDIR}/intel-linux-firmware/tgl_guc_70.bin* ${D}${nonarch_base_libdir}/firmware/i915/tgl_guc_70.bin
        install -m 644 ${WORKDIR}/intel-linux-firmware/adlp_guc_70.bin* ${D}${nonarch_base_libdir}/firmware/i915/adlp_guc_70.bin
}
