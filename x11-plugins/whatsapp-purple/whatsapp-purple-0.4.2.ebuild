# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit toolchain-funcs

MY_PV=${PV%.*}-${PV##*.}
DESCRIPTION="WhatsApp protocol implementation for libpurple (Pidgin)"
HOMEPAGE="http://davidgf.net/page/39/whatsapp-on-your-computer:-pidgin-plugin"
SRC_URI="https://github.com/davidgfnet/${PN}/archive/v${MY_PV}.tar.gz -> ${PN}-${MY_PV}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-libs/glib:2
	net-im/pidgin"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/${PN}-${MY_PV}"

src_compile() {
	emake CC="$(tc-getCC)" CXX="$(tc-getCXX)" \
		CFLAGS="${CFLAGS} -fPIC -DPURPLE_PLUGINS -DPIC \$(CFLAGS_PURPLE)" \
		LDFLAGS="${LDFLAGS} -shared"
}
