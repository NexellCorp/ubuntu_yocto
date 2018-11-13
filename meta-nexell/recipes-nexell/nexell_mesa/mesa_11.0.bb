require mesa.inc

SRC_URI = "file://mesa"

FILESEXTRAPATHS_prepend := "${THISDIR}:"

S = "${WORKDIR}/mesa"

DEPENDS += "python-mako python-mako-native"

#because we cannot rely on the fact that all apps will use pkgconfig,
#make eglplatform.h independent of MESA_EGL_NO_X11_HEADER
do_install_append() {
    if ${@bb.utils.contains('PACKAGECONFIG', 'egl', 'true', 'false', d)}; then
            sed -i -e 's/^#ifdef MESA_EGL_NO_X11_HEADERS$/#if defined(MESA_EGL_NO_X11_HEADERS) || ${@bb.utils.contains('PACKAGECONFIG', 'x11', '0', '1', d)}/' ${D}${includedir}/EGL/eglplatform.h
