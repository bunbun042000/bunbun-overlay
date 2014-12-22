# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit eutils

DESCRIPTION="Create entire CD wave/cue script file"
HOMEPAGE=""
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND="
    app-cdr/cdrdao
	app-cdr/cuetools
	app-i18n/nkf
	media-sound/cdparanoia"
RDEPEND="${DEPEND}"

src_install() {
    dodir /usr/bin/
	dobin "${FILESDIR}"/CreateCDImage
}
