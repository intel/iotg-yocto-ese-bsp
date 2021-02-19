FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI_append = "\
                   file://ptp_user_interface.patch \
                   file://0001-net-xdp-add-txtime-field-in-xdp_desc-in-header-file.patch \
                  "
