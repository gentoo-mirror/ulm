# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit check-reqs

DESCRIPTION="Nalimov chess endgame tablebases for up to 5 pieces"
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
SRC_URI+=" 5-pieces? ("
for i in "${tb5[@]}"; do
	SRC_URI+=" http://tablebase.sesse.net/3-4-5/${i}.nbw.emd"
	SRC_URI+=" http://tablebase.sesse.net/3-4-5/${i}.nbb.emd"
done
SRC_URI+=" )"
unset i j k m tb34 tb5

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+5-pieces"
RESTRICT="mirror"				# not on Gentoo mirrors

S="${WORKDIR}"

CHECKREQS_DISK_USR="7230M"
CHECKREQS_DISK_BUILD="${CHECKREQS_DISK_USR}"

pkg_pretend() {
	use 5-pieces && check-reqs_pkg_pretend
}

pkg_setup() {
	use 5-pieces && check-reqs_pkg_setup
}

src_unpack() { :; }

src_install() {
	local f
	insinto /usr/share/${PN}
	for f in ${A}; do
		[[ ${f} = *.emd ]] && echo "${DISTDIR}"/${f}
	done | xargs doins
	newdoc "${DISTDIR}"/${P}-README README
}
