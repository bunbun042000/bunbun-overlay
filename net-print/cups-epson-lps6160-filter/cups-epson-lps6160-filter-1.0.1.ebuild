# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

GENTOO_DEPEND_ON_PERL=no

inherit perl-module systemd flag-o-matic
P="epson-laser-printer-lp-s6160-${PV}"

if [[ "${PV}" == "9999" ]] ; then
	inherit autotools git-r3
	EGIT_REPO_URI="https://github.com/OpenPrinting/cups-filters.git"
else
	SRC_URI="https://download3.ebz.epson.net/dsc/f/03/00/05/37/10/f510390b07cf1e338e842b0e5e69358e67a87b86/${P}.tar.gz"
	KEYWORDS="~alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 sparc x86 ~m68k-mint"
fi
DESCRIPTION="EPSON LP-S6160 Cups filter"
HOMEPAGE="http://download.ebz.epson.net/dsc/du/02/DriverDownloadInfo.do?LG2=JA&CN2=&DSCMI=53710&DSCCHK=b6c493888cbf1613f07691121afaf2bac3092505"

LICENSE="MIT GPL-2"
SLOT="0"
IUSE=""

RDEPEND="
	net-print/cups
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${P}"

src_prepare() {
	default
	[[ "${PV}" == "9999" ]] && eautoreconf

	# Bug #626800
	append-cxxflags -std=c++11
}

src_configure() {
	local myeconfargs=(
		--localstatedir="${EPREFIX}"/var
		--with-cups-rundir="${EPREFIX}"/run/cups
		--disable-shared
	)
	econf "${myeconfargs[@]}"
}

src_compile() {
	default

}

src_install() {
	default

	find "${ED}" \( -name "*.a" -o -name "*.la" \) -delete || die

	cp "${FILESDIR}"/cups-browsed.init.d-r1 "${T}"/cups-browsed || die

}


