# in meta-layers-build only, sed packages is required to resolve core-image-sato-sdk dnf issue 
# Error:
#  Problem: conflicting requests
#   - nothing provides /bin/sed needed by kernel-devsrc-1.0-r0.intel_corei7_64 from oe-repo
RDEPENDS:${PN}:append:x86-64 = " sed"