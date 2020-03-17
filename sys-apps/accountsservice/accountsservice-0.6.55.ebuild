# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
#GNOME2_EAUTORECONF="yes"

inherit gnome2 systemd meson

DESCRIPTION="D-Bus interfaces for querying and manipulating user account information"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/AccountsService/"
SRC_URI="https://www.freedesktop.org/software/${PN}/${P}.tar.xz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~ia64 ppc ppc64 ~sparc x86"

IUSE="doc consolekit elogind +introspection selinux systemd"
REQUIRED_USE="^^ ( consolekit elogind systemd )"

CDEPEND="
	>=dev-libs/glib-2.44:2
	sys-auth/polkit
	consolekit? ( sys-auth/consolekit )
	elogind? ( >=sys-auth/elogind-229.4 )
	introspection? ( >=dev-libs/gobject-introspection-0.9.12:= )
	systemd? ( >=sys-apps/systemd-186:0= )
"
DEPEND="${CDEPEND}
	dev-libs/libxslt
	dev-util/gdbus-codegen
	>=dev-util/gtk-doc-am-1.15
	>=dev-util/intltool-0.40
	sys-devel/gettext
	virtual/pkgconfig
	doc? (
		app-text/docbook-xml-dtd:4.1.2
		app-text/xmlto )
"
RDEPEND="${CDEPEND}
	selinux? ( sec-policy/selinux-accountsd )
"


src_configure() {
	local emesonargs=(
		--localstatedir="${EPREFIX}"/var \
		-Denable-admin-group="wheel" \
		-Dwith-systemdsystemunitdir="$(systemd_get_systemunitdir)" \
		-Ddoc=$(usex doc docbook-docs) \
		-Delogind=$(usex elogind true false) \
		-Dintrospection=$(usex introspection true false) \
		-Dsystemd=$(usex systemd true false)
		)
		meson_src_configure
}

