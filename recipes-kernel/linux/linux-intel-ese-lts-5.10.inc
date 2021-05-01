KBRANCH = "5.10/yocto"
KMETA_BRANCH = "yocto-5.10"
SRCREV_meta = "b3801b94bc102a9a01292daa48db3c04e39652e7"
SRCREV_machine ?= "ebfd52dae652c399a67cbce82e39d37f4ea191fb"
LINUX_VERSION ?= "5.10.26"
LIC_FILES_CHKSUM = "file://COPYING;md5=6bc538ed5bd9a7fc9398086aedcd7e46"

SRC_URI_append = " file://bsp/${BSP_SUBTYPE}/audio-adl.scc"
