# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/iscan-data/iscan-data-1.22.0.1.ebuild,v 1.5 2013/05/20 08:32:39 ago Exp $

EAPI=5

inherit eutils versionator udev multilib

MY_PV="$(get_version_component_range 1-3)"
MY_PVR="$(replace_version_separator 3 -)"

DESCRIPTION="Image Scan! for Linux data files"
HOMEPAGE="http://download.ebz.epson.net/dsc/search/01/search/?OSC=LX"
SRC_URI="http://a1227.g.akamai.net/f/1227/40484/7d/download.ebz.epson.net/dsc/f/01/00/02/77/29/2777facabfdc9f382869253673debd53f1c6281f/iscan-data_1.28.0-2.tar.gz"
LICENSE="GPL-2"
SLOT="0"

KEYWORDS="amd64 x86"
IUSE="udev"

DEPEND="udev? (
		dev-libs/libxslt
		media-gfx/sane-backends
	)"
RDEPEND=""

S="${WORKDIR}/${PN}-${MY_PV}"

DOCS=( NEWS SUPPORTED-DEVICES KNOWN-PROBLEMS )

src_install() {
	default

	if use udev; then
	# create udev rules
		local rulesdir=$(get_udevdir)/rules.d
		dodir ${rulesdir}
		"${D}usr/$(get_libdir)/iscan-data/make-policy-file" \
			--force --quiet --mode udev \
			-d "${D}usr/share/iscan-data/epkowa.desc" \
			-o "${D}${rulesdir}/99-iscan.rules" || die
	fi
}
