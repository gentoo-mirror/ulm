# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit check-reqs

DESCRIPTION="Nalimov endgame tablebases for up to 5 pieces"
HOMEPAGE="http://tablebase.sesse.net/"

pc=(q r b n p)
for ((i=0; i<5; i++)); do
	tb4+=(k${pc[i]}k) # 2+1
	for ((j=i; j<5; j++)); do
		tb4+=(k${pc[i]}k${pc[j]} k${pc[i]}${pc[j]}k) # 2+2, 3+1
		for ((k=0; k<5; k++)); do
			tb5+=(k${pc[i]}${pc[j]}k${pc[k]}) # 3+2
			((k>=j)) && tb5+=(k${pc[i]}${pc[j]}${pc[k]}k) # 4+1
		done
	done
done

SRC_URI="http://tablebase.sesse.net/README -> ${P}-README"
for i in "${tb4[@]/%/.nbw}" "${tb4[@]/%/.nbb}"; do
	SRC_URI+=" http://tablebase.sesse.net/3-4-5/${i}.emd"
done
SRC_URI+=" tb5? ("
for i in "${tb5[@]/%/.nbw}" "${tb5[@]/%/.nbb}"; do
	SRC_URI+=" http://tablebase.sesse.net/3-4-5/${i}.emd"
done
SRC_URI+=" )"
unset i j k pc tb4 tb5

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
	insinto /usr/share/games/${PN}
	doins "${DISTDIR}"/*.emd
	newdoc "${DISTDIR}"/${P}-README README
}
