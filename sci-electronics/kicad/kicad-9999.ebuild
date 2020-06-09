# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="7"
PYTHON_COMPAT=( python2_7 )

WX_GTK_VER="3.0"

inherit cmake-utils wxwidgets fdo-mime git-r3 gnome2-utils python-r1 flag-o-matic

DESCRIPTION="Electronic Schematic and PCB design tools."
HOMEPAGE="http://www.kicad-pcb.org"

LICENSE="GPL-2"
SLOT="0"
EGIT_REPO_URI="https://gitlab.com/kicad/code/kicad.git"

KEYWORDS="~amd64"

IUSE="dev-doc debug doc examples minimal python nanometr gost sexpr github"

LANGS="bg ca cs de el_GR en es fi fr hu it ja ko nl pl pt ru sl sv zh_CN"

for lang in ${LANGS}; do
	IUSE+=" linguas_${lang}"
done

CDEPEND="x11-libs/wxGTK:${WX_GTK_VER}[X,opengl,webkit]
         dev-python/wxpython:${WX_GTK_VER}
         media-libs/glew"
DEPEND="${CDEPEND}
	>=dev-util/cmake-2.6.0
	>=dev-libs/boost-1.40[python?]
	app-arch/xz-utils
	dev-doc? ( app-doc/doxygen )"
RDEPEND="${CDEPEND}
	sys-libs/zlib
	sci-electronics/electronics-menu
	!minimal? ( !sci-electronics/kicad-library )"

src_unpack() {
	git-r3_checkout
	
	if use doc; then
		EGIT_REPO_URI="https://gitlab.com/kicad/services/kicad-doc.git" \
		EGIT_CHECKOUT_DIR="${WORKDIR}/${P}/kicad-doc" \
		git-r3_checkout
	fi

	if ! use minimal; then
		EGIT_REPO_URI="https://github.com/KiCad/kicad-library.git" \
		EGIT_CHECKOUT_DIR="${WORKDIR}/${P}/kicad-library" \
		git-r3_checkout
	fi
}

src_prepare() {
	eapply_user
#	if use python;then
#		# dev-python/wxpython don't support python3
#		sed '/set(_PYTHON3_VERSIONS 3.3 3.2 3.1 3.0)/d' -i CMakeModules/FindPythonLibs.cmake || die "sed failed"
#	fi

	if use doc;then
		for lang in ${LANGS};do
			for x in ${lang};do
				if ! use linguas_${x}; then
					sed "s| \<${x}\>||" -i kicad-doc/{internat,doc/{help,tutorials}}/CMakeLists.txt || die "sed failed"
				fi
			done
		done
	fi
	# hack or dev-vcs/bzrtools
#	sed 's|bzr patch -p0|patch -p0 -i|g' -i CMakeModules/download_boost.cmake

	#fdo
	sed -e 's/Categories=Development;Electronics$/Categories=Development;Electronics;/' \
		-i resources/linux/mime/applications/*.desktop || die 'sed failed'

	# Add important doc files
	sed -e 's/INSTALL.txt/AUTHORS.txt CHANGELOG.txt README.txt TODO.txt/' -i CMakeLists.txt || die "sed failed"

	# Handle optional minimal install
	if use minimal; then
		sed -e '/add_subdirectory( template )/d' -i CMakeLists.txt || die "sed failed"
	else
		sed '/add_subdirectory( bitmaps_png )/a add_subdirectory( kicad-library )' -i CMakeLists.txt || die "sed failed"
		sed '/make uninstall/,/# /d' -i kicad-library/CMakeLists.txt || die "sed failed"
	fi

	# Add documentation and fix necessary code if requested
	if use doc; then
		sed '/add_subdirectory( bitmaps_png )/a add_subdirectory( kicad-doc )' -i CMakeLists.txt || die "sed failed"
		sed '/make uninstall/,$d' -i kicad-doc/CMakeLists.txt || die "sed failed"
	fi

	# Install examples in the right place if requested
	if use examples; then
		sed -e 's:${KICAD_DATA}/demos:${KICAD_DOCS}/examples:' -i CMakeLists.txt || die "sed failed"
	else
		sed -e '/add_subdirectory( demos )/d' -i CMakeLists.txt || die "sed failed"
	fi

	cmake-utils_src_prepare
}

src_configure() {
#	bzr whoami "anonymous"
	if use amd64;then
		append-cxxflags -fPIC
	fi
#	need-wxwidgets unicode

	local mycmakeargs=(${mycmakeargs}
		-DKICAD_DOCS=/usr/share/doc/${PF}
		-DBUILD_GITHUB_PLUGIN="$(usex github)"
		-DKICAD_SCRIPTING="$(usex python)"
		-DKICAD_SCRIPTING_MODULES="$(usex python)"
		-DKICAD_SCRIPTING_WXPYTHON="$(usex python)")
	cmake-utils_src_configure
}

src_compile() {
	use dev-doc && doxygen Doxyfile
}

src_install() {
	cmake-utils_src_install
	if use dev-doc ; then
		insinto /usr/share/doc/${PF}
		doins uncrustify.cfg
		cd Documentation
		doins -r GUI_Translation_HOWTO.pdf guidelines/UIpolicies.txt doxygen/*
	fi
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update

	if use minimal ; then
		ewarn "If the schematic and/or board editors complain about missing libraries when you"
		ewarn "open old projects, you will have to take one or more of the following actions :"
		ewarn "- Install the missing libraries manually."
		ewarn "- Remove the libraries from the 'Libs and Dir' preferences."
		ewarn "- Fix the libraries' locations in the 'Libs and Dir' preferences."
		ewarn "- Emerge kicad without the 'minimal' USE flag."
		elog
	fi
	elog "You may want to emerge media-gfx/wings if you want to create 3D models of components."
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
}
