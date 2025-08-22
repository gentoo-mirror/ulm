# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Convert binary data to ASCII text"
HOMEPAGE="https://base91.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/project/${PN}/basE91/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}"
}

src_install() {
	emake prefix=/usr DESTDIR="${D}" install
	dodoc README NEWS
}
