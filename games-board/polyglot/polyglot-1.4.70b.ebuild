# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Chess engine Winboard/xboard to UCI protocol adapter"
HOMEPAGE="http://hardy.uhasselt.be/Toga/"
# Not entirely clear what the "b" stands for; it first appeared
# in version 1.4w10UCIb6 following 1.4w10
SRC_URI="http://hardy.uhasselt.be/Toga/polyglot-release/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_configure() {
	econf \
		--bindir="/usr/games/bin" \
		--docdir="/usr/share/doc/${PF}"
}
