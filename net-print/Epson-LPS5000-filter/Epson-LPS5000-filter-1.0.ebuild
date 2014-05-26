# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils

DESCRIPTION="Epson LP-S5000 driver for Linux"
HOMEPAGE="http://download.ebz.epson.net/dsc/search/01/search/"
SRC_URI="http://a1227.g.akamai.net/f/1227/40484/7d/download.ebz.epson.net/dsc/f/01/00/01/68/22/1a63373e1faa5ffd7a2acd34ceba9e89c0c47d7e/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="net-print/cups
        app-text/ghostscript-gpl
		sys-apps/sed
		sys-apps/grep
		sys-apps/gawk
		sys-devel/bc
        app-text/psutils
        sys-libs/libstdc++-v3"

RDEPEND="${DEPEND}"

src_prepare() {
        epatch "${FILESDIR}/${P}_pstolps5000.sh.patch"
}

