# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils qt4-r2 subversion

DESCRIPTION="Environment for authoring TeX/LaTeX/ConTeXt with focus on usability"
HOMEPAGE="http://code.google.com/p/texworks"
SRC_URI=""
ESVN_REPO_URI="http://texworks.googlecode.com/svn/trunk/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	>=dev-qt/qtcore-4.5:4
	app-text/poppler[qt4]
	dev-qt/designer
	dev-qt/qtdbus
	>=app-text/hunspell-1.2.2"
RDEPEND="${DEPEND}"

src_install() {
	domenu "${FILESDIR}"/texworks.desktop
	doicon "${FILESDIR}"/icon/texworks.png
	dobin texworks
}
