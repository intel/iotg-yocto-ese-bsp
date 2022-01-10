FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI_append = " \
file://ptp/0001-drivers-ptp-Add-Enhanced-handling-of-reserve-fields.patch \
file://ptp/0002-drivers-ptp-Add-PEROUT2-ioctl-frequency-adjustment-i.patch \
file://ptp/0003-drivers-ptp-Add-user-space-input-polling-interface.patch \
"
