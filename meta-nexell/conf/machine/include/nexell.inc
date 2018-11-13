PREFERRED_PROVIDER_virtual/xserver ?= "xserver-xorg"
PREFERRED_PROVIDER_virtual/egl ?= "mesa"
PREFERRED_PROVIDER_virtual/libgl ?= "mesa"
PREFERRED_PROVIDER_virtual/libgles1 ?= "mesa"
PREFERRED_PROVIDER_virtual/libgles2 ?= "mesa"

XSERVER ?= "xserver-xorg \
            ${@bb.utils.contains('DISTRO_FEATURES', 'opengl', 'mesa-driver-swrast', '', d)} \
            xf86-input-evdev \
            xf86-input-mouse \
            xf86-video-fbdev \
            xf86-input-keyboard"

MACHINE_FEATURES = "alsa bluetooth usbgadget screen"

IMAGE_FSTYPES += "tar.bz2 ext4"
