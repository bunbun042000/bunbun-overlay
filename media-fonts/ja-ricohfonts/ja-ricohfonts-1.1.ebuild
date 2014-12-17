# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils versionator rpm font
DESCRIPTION="This is a ja ricohfonts from starsuite9"

# Homepage, not used by Portage directly but handy for developer reference
HOMEPAGE="http://foo.example.org/"

MY_P="starsuite9-ja-ricohfonts-9.0.0-9358"
SRC_URI="ftp://foo.example.org/${MY_P}.i586.rpm"


LICENSE=""

SLOT="0"

KEYWORDS="~amd64 ~x86"

IUSE="X"

RESTRICT="fetch"


#DEPEND=""

RDEPEND="${DEPEND}"
S=${WORKDIR}

pkg_nofetch() {
	einfo "Please fetch ${MY_P}"
	einfo "from StarSuite9 and place it in ${DISTDIR}"
}

src_unpack() {
	rpm_src_unpack ${A}
}

FONT_SUFFIX="ttf ttc"
FONT_S="${WORKDIR}/opt/openoffice.org/basis3.0/share/fonts/truetype/"
FONT_PN="ja-ricohfonts"
FONT_CONF=( "${FILESDIR}"/77-${PN}.conf )
