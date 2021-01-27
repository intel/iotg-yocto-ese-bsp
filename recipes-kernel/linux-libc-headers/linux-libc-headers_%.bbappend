FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append = "${@bb.utils.contains('DISTRO_FEATURES', 'libc-abi-breaker-xdp', ' file://0001-net-xdp-add-txtime-field-in-xdp_desc-in-header-file.patch', '', d)}"

python(){
  xdp_message = """
***********************************************************************
*** You have libc-abi-breaker-xdp set in DISTRO_FEATURES
*** This breaks libc ABI compatibility
*** Please also ensure the running kernel has a consistent if_xdp.h ABI
*** and inspect the patches if needed in:
*** {0}
***********************************************************************
"""

  ft = d.getVar('DISTRO_FEATURES') or ''
  dir = d.getVar('THISDIR')
  if 'libc-abi-breaker-xdp' in ft.split():
    bb.warn(xdp_message.format(dir))
}
