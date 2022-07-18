# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Quotes from OpenBSD founder Theo de Raadt"
HOMEPAGE="https://github.com/hboetes/mg/commit/e895fcbdb9c69bb60ebe4e2a71014fd734242d6e"
# split off from app-editors/mg
#SRC_URI="http://homepage.boetes.org/software/mg/mg-${PV}.tar.gz"
SRC_URI="https://dev.gentoo.org/~ulm/distfiles/mg-${PV}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="games-misc/fortune-mod"
RDEPEND="${DEPEND}"

S="${WORKDIR}/mg-${PV}"

src_configure() { :; }

src_compile() {
	sed -e '1,/talk.*{/d;/^}/,$d;s/^[ \t]*"\(.*\)",\?[ \t]*$/\1\n%/' \
		theo.c | fold -s -w 70 >theo-de-raadt || die
	strfile theo-de-raadt || die
}

src_install() {
	insinto /usr/share/fortune
	doins theo-de-raadt{,.dat}
}
