# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python{2_6,2_7} )
PYTHON_REQ_USE="sqlite"

inherit fdo-mime multilib python-r1

DESCRIPTION="a media player aiming to be similar to AmaroK, but for GTK+"
HOMEPAGE="http://www.exaile.org/"
SRC_URI="http://launchpad.net/${PN}/3.3.x/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-2 GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="cddb libnotify nls"

RDEPEND="dev-python/dbus-python
	>=media-libs/mutagen-1.10
	>=dev-python/pygtk-2.17
	>=dev-python/pygobject-2.18:2
	dev-python/gst-python:0.10
	media-libs/gst-plugins-good:0.10
	media-plugins/gst-plugins-meta:0.10
	libnotify? ( dev-python/notify-python )
	cddb? ( dev-python/cddb-py )"
DEPEND="nls? ( dev-util/intltool
	sys-devel/gettext )"

RESTRICT="test" #315589

src_compile() {
	if use nls; then
		emake locale || die
	fi
}

src_install() {
	emake \
		PREFIX=/usr \
		LIBINSTALLDIR=/$(get_libdir) \
		DESTDIR="${D}" \
		install$(use nls || echo _no_locale) || die

	dodoc FUTURE || die
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}
