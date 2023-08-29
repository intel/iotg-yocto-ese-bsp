# PSIRT: PTK0003132 GuC Firmware is required to solve the vulnerability issue

SRC_URI:append = " https://github.com/intel/intel-linux-firmware/raw/fe7265aa57e9aa9d6d4b8b06e7ed2048e7075834/adlp_guc_70.bin;subdir=intel-linux-firmware;name=adlp_guc \
		   https://github.com/intel/intel-linux-firmware/raw/fe7265aa57e9aa9d6d4b8b06e7ed2048e7075834/tgl_guc_70.bin;subdir=intel-linux-firmware;name=tgl_guc \
		 "

SRC_URI[adlp_guc.sha256sum] = "af0a206272b643d7e43945f58e8df584aa139d29ad90a7f658d5bd8de245bc11"
SRC_URI[tgl_guc.sha256sum] = "24810e6597d8da71026824ce840d17346efdcb74303874235fe3911a6f89ef1f"

do_install:append () {
        install -m 644 ${WORKDIR}/intel-linux-firmware/tgl_guc_70.bin ${D}${nonarch_base_libdir}/firmware/i915/tgl_guc_70.bin
        install -m 644 ${WORKDIR}/intel-linux-firmware/adlp_guc_70.bin ${D}${nonarch_base_libdir}/firmware/i915/adlp_guc_70.bin
}
