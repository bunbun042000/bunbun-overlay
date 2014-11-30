# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

MY_P="${P}-1lsb3.2"

DESCRIPTION="Epson Inkjet Printer Driver (ESC/P-R) for Linux"
HOMEPAGE="http://download.ebz.epson.net/dsc/search/01/search/"
SRC_URI="file://${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="net-print/cups"
RDEPEND="${DEPEND}"

pkg_nofetch() {
        einfo "Please download"
        einfo "  -  ${MY_P}.tar.gz"
        einfo "from ${HOMEPAGE} and place it in ${DISTDIR}"
}

