# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit latex-package

DESCRIPTION="The vc (version control) bundle"
HOMEPAGE="https://www.ctan.org/pkg/vc"
SRC_URI="http://mirrors.ctan.org/support/${PN}.zip"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="app-arch/unzip"

S="${WORKDIR}/${PN}"

src_compile() { :; }

src_install() {
	insinto ${TEXMF}/scripts/${PN}
	doins -r bzr-unix git-unix svn-unix
	latex-package_src_doinstall pdf
	dodoc CHANGES README
}
