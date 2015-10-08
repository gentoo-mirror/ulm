# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit check-reqs

DESCRIPTION="Nalimov endgame tablebases for up to 5 pieces"
HOMEPAGE="http://tablebase.sesse.net/"

tb34=()
tb5=()
m=(p n b r q k)
for ((i=4; i>=0; i--)); do
	tb34+=(k${m[i]}k) # 2+1
	for ((j=i; j>=0; j--)); do
		tb34+=(k${m[i]}k${m[j]} k${m[i]}${m[j]}k) # 2+2, 3+1
		for ((k=4; k>=0; k--)); do
			tb5+=(k${m[i]}${m[j]}k${m[k]}) # 3+2
			((k<=j)) && tb5+=(k${m[i]}${m[j]}${m[k]}k) # 4+1
		done
	done
done

SRC_URI="http://tablebase.sesse.net/README -> ${P}-README"
for i in "${tb34[@]}"; do
	SRC_URI+=" http://tablebase.sesse.net/3-4-5/${i}.nbw.emd"
	SRC_URI+=" http://tablebase.sesse.net/3-4-5/${i}.nbb.emd"
done
SRC_URI+=" tb5? ("
for i in "${tb5[@]}"; do
	SRC_URI+=" http://tablebase.sesse.net/3-4-5/${i}.nbw.emd"
	SRC_URI+=" http://tablebase.sesse.net/3-4-5/${i}.nbb.emd"
done
SRC_URI+=" )"
unset i j k m tb34 tb5

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+tb5"
RESTRICT="mirror"				# not on Gentoo mirrors

S="${WORKDIR}"

CHECKREQS_DISK_USR="7230M"
CHECKREQS_DISK_BUILD="${CHECKREQS_DISK_USR}"

pkg_pretend() {
	use tb5 && check-reqs_pkg_pretend
}

pkg_setup() {
	use tb5 && check-reqs_pkg_setup
}

src_unpack() { :; }

src_install() {
	insinto /usr/share/${PN}
	doins "${DISTDIR}"/*.emd
	newdoc "${DISTDIR}"/${P}-README README
}
