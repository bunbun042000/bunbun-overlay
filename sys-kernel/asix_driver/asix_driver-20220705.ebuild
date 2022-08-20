# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-mod udev

#MY_COMMIT="c216cc41a2f9e4b4bc356fb2ca17359275a4f3cd"

DESCRIPTION="USB ASIX ethernet driver"
HOMEPAGE="https://github.com/lambdaconcept/ft60x_driver"
SRC_URI="https://www.asix.com.tw/en/support/download/file/1305?time=1660953780241 -> ${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"

KEYWORDS="amd64 ~arm64 x86"
IUSE=""

S="${WORKDIR}/ASIX_USB_NIC_Linux_Driver_Source_v1.0.0"

MODULE_NAMES="ax_usb_nic(usb:${S}:${S})"
BUILD_TARGETS="all"

pkg_setup() {
	linux-mod_pkg_setup
}

src_install() {
	linux-mod_src_install
}
