DEPENDS:append = "${@bb.utils.contains('DISTRO_FEATURES', 'kernel-compress-modules', ' xz-native gzip-native', '', d)}"
