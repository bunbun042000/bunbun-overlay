# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=7

inherit eutils

DESCRIPTION="WIDE-DHCPv6 is an open-source implementation of DHCP for IPv6"

HOMEPAGE="http://wide-dhcpv6.sourceforge.net/"
SRC_URI="mirror://sourceforge/wide-dhcpv6/${P}.tar.gz"

PATCHES=( 
	"${FILESDIR}/${P}.Fedora9.patch"
	"${FILESDIR}/${P}.gentoo.patch"
)

LICENSE="BSD"

SLOT="0"

KEYWORDS="~x86 ~amd64"

IUSE=""

DEPEND=""

RDEPEND="${DEPEND}"

src_prepare() {
     eapply ${PATCHES[@]}
     eapply_user
}

src_install() {
	einstall || die "einstall failed"
}
