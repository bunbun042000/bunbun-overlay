# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="7"

PYTHON_COMPAT=( python3_{7,8,9} )

WX_GTK_VER="3.0-gtk3"

inherit check-reqs cmake eutils python-single-r1 toolchain-funcs wxwidgets xdg-utils git-r3

DESCRIPTION="Electronic Schematic and PCB design tools."
HOMEPAGE="http://www.kicad-pcb.org"

LICENSE="GPL-2"
SLOT="0"
EGIT_REPO_URI="https://gitlab.com/kicad/code/kicad.git"

#KEYWORDS="*"

IUSE="doc examples github +ngspice occ +oce openmp +python"

REQUIRED_USE="
	python? ( ${PYTHON_REQUIRED_USE} )
	?? ( occ oce )
"

COMMON_DEPEND="
	>=dev-libs/boost-1.61:=[context,nls,threads]
	media-libs/freeglut
	media-libs/glew:0=
	>=media-libs/glm-0.9.9.1
	media-libs/mesa[X(+)]
	>=x11-libs/cairo-1.8.8:=
	>=x11-libs/pixman-0.30
	x11-libs/wxGTK:${WX_GTK_VER}[X,opengl]
	github? ( net-misc/curl:=[ssl] )
	ngspice? (
		>sci-electronics/ngspice-27[shared]
	)
	occ? ( >=sci-libs/opencascade-6.8.0:= )
	oce? ( sci-libs/oce )
	python? (
		$(python_gen_cond_dep '
			>=dev-libs/boost-1.61:=[context,nls,threads,python,${PYTHON_MULTI_USEDEP}]
			dev-python/wxpython:4.0[${PYTHON_MULTI_USEDEP}]
		')
		${PYTHON_DEPS}
	)
"

DEPEND="${COMMON_DEPEND}
	python? ( >=dev-lang/swig-3.0:0 )"
RDEPEND="${COMMON_DEPEND}
	sci-electronics/electronics-menu
"
BDEPEND="doc? ( app-doc/doxygen )"
CHECKREQS_DISK_BUILD="800M"

pkg_setup() {
	use python && python-single-r1_pkg_setup
	use openmp && tc-check-openmp
	setup-wxwidgets
	check-reqs_pkg_setup
}

src_unpack() {
	git-r3_fetch
	git-r3_checkout

	if use doc; then
		EGIT_REPO_URI="https://gitlab.com/kicad/services/kicad-doc.git" \
		EGIT_CHECKOUT_DIR="${WORKDIR}/${P}/kicad-doc" \
		git-r3_fetch
		EGIT_REPO_URI="https://gitlab.com/kicad/services/kicad-doc.git" \
		EGIT_CHECKOUT_DIR="${WORKDIR}/${P}/kicad-doc" \
		git-r3_checkout
	fi

	EGIT_REPO_URI="https://github.com/KiCad/kicad-library.git" \
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}/kicad-library" \
	git-r3_fetch
	EGIT_REPO_URI="https://github.com/KiCad/kicad-library.git" \
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}/kicad-library" \
	git-r3_checkout

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
#	sed -e 's/Categories=Development;Electronics$/Categories=Development;Electronics;/' \
#		-i resources/linux/mime/applications/*.desktop || die 'sed failed'

	# Add important doc files
	sed -e 's/INSTALL.txt/AUTHORS.txt CHANGELOG.txt README.txt TODO.txt/' -i CMakeLists.txt || die "sed failed"

		sed '/add_subdirectory( bitmaps_png )/a add_subdirectory( kicad-library )' -i CMakeLists.txt || die "sed failed"
		sed '/make uninstall/,/# /d' -i kicad-library/CMakeLists.txt || die "sed failed"

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

	cmake_src_prepare
}

src_configure() {
	xdg_environment_reset

	local mycmakeargs=(
		-DKICAD_DOCS="${EPREFIX}/usr/share/doc/${PF}"
		-DKICAD_HELP="${EPREFIX}/usr/share/doc/${PN}-doc-${PV}"
		-DBUILD_GITHUB_PLUGIN="$(usex github)"
		-DKICAD_SCRIPTING="$(usex python)"
		-DKICAD_SCRIPTING_MODULES="$(usex python)"
		-DKICAD_SCRIPTING_WXPYTHON="$(usex python)"
		-DKICAD_SCRIPTING_WXPYTHON_PHOENIX="$(usex python)"
		-DKICAD_SCRIPTING_PYTHON3="$(usex python)"
		-DKICAD_SCRIPTING_ACTION_MENU="$(usex python)"
		-DKICAD_SPICE="$(usex ngspice)"
		-DKICAD_USE_OCC="$(usex occ)"
		-DKICAD_USE_OCE="$(usex oce)"
		-DKICAD_INSTALL_DEMOS="$(usex examples)"
		-DCMAKE_SKIP_RPATH="ON"
	)
	use python && mycmakeargs+=(
		-DPYTHON_DEST="$(python_get_sitedir)"
		-DPYTHON_EXECUTABLE="${PYTHON}"
		-DPYTHON_INCLUDE_DIR="$(python_get_includedir)"
		-DPYTHON_LIBRARY="$(python_get_library_path)"
	)
	use occ && mycmakeargs+=(
		-DOCC_INCLUDE_DIR="${CASROOT}"/include/opencascade
		-DOCC_LIBRARY_DIR="${CASROOT}"/lib
	)

	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	if use doc; then
		cmake_src_compile dev-docs doxygen-docs
	fi
}

src_install() {
	cmake_src_install
	use python && python_optimize
	if use doc ; then
		dodoc uncrustify.cfg
		cd Documentation || die
		dodoc -r *.txt kicad_doxygen_logo.png notes_about_pcbnew_new_file_format.odt doxygen/. development/doxygen/.
	fi
}

pkg_postinst() {
	optfeature "Component symbols library" sci-electronics/kicad-symbols
	optfeature "Component footprints library" sci-electronics/kicad-footprints
	optfeature "3D models of components " sci-electronics/kicad-packages3d
	optfeature "Project templates" sci-electronics/kicad-templates
	optfeature "Different languages for GUI" sci-electronics/kicad-i18n
	optfeature "Extended documentation" app-doc/kicad-doc
	optfeature "Creating 3D models of components" media-gfx/wings

	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	xdg_icon_cache_update
}
