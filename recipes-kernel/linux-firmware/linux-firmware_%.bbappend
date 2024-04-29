# SRIOV support to use GuC 70.20.0

SRC_URI:append = " https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/i915/adlp_guc_70.bin?h=20240220;subdir=intel-linux-firmware;name=adlp_guc \
		   https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/i915/tgl_guc_70.bin?h=20240220;subdir=intel-linux-firmware;name=tgl_guc \
		 "
SRC_URI[adlp_guc.sha256sum] = "7ced45b75492078675639e5b0dcd81b068b8f51e75843643d4c7ef8fe0e046a1"
SRC_URI[tgl_guc.sha256sum] = "04342a17567daf60d720c1f82d9af25b83941396bb99334ff7dbda8ccfc8013f"

do_install:append () {
        install -m 644 ${WORKDIR}/intel-linux-firmware/tgl_guc_70.bin* ${D}${nonarch_base_libdir}/firmware/i915/tgl_guc_70.bin
        install -m 644 ${WORKDIR}/intel-linux-firmware/adlp_guc_70.bin* ${D}${nonarch_base_libdir}/firmware/i915/adlp_guc_70.bin
}
