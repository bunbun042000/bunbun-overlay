# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/yatex/yatex-1.77.ebuild,v 1.4 2013/08/07 13:26:32 ago Exp $

EAPI=5

inherit elisp eutils

DESCRIPTION="Enhancement of auto-save-buffers"
HOMEPAGE="http://blog.kentarok.org/entry/20080222/1203688543"
SRC_URI="ftp://ftp2.jp.freebsd.org/pub/linux/momonga/development/source/SOURCES/IIIMECF-${PV}.tar.gz"

KEYWORDS="amd64 ppc ~ppc64 x86"
SLOT="0"
LICENSE="GPL=2+"

DEPEND="app-i18n/atokx3
		virtual/emacs"

SITEFILE="50${PN}-gentoo.el"
S="${WORKDIR}/${PN}"

src_compile() {

	emacs -q --no-site-file -batch -l iiimcf-comp.el
}

src_install() {
	elisp-install ${PN} lisp/*.el* || die

	elisp-site-file-install "${FILESDIR}/${SITEFILE}"|| die

}
