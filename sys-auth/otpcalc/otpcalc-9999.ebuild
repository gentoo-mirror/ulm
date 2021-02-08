# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3 meson

DESCRIPTION="A One Time Password and S/Key calculator for X"
HOMEPAGE="http://www.killa.net/infosec/otpCalc/"
EGIT_REPO_URI="https://gitlab.com/ulm/otpcalc.git"

LICENSE="GPL-2+" # bundled crypto functions are not used
SLOT="0"

RDEPEND="dev-libs/openssl:0=
	x11-libs/gtk+:3"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_configure() {
	local emesonargs=( -Dlibcrypto=enabled )
	meson_src_configure
}

src_install() {
	meson_src_install
	dosym otpCalc /usr/bin/otpcalc
	newman - otpcalc.1 <<< ".so man1/otpCalc.1"
}
