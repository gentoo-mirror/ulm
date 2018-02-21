# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Nalimov chess endgame tablebases for up to 6 pieces"
HOMEPAGE="http://tablebase.sesse.net/
	http://kirill-kryukov.com/chess/tablebases-online/"

tb34=()
m=(p n b r q k)
for ((i=4; i>=0; i--)); do
	tb34+=(k${m[i]}k.nb{w,b}) # 2+1
	for ((j=i; j>=0; j--)); do
		tb34+=(k${m[i]}k${m[j]}.nb{w,b} k${m[i]}${m[j]}k.nb{w,b}) # 2+2, 3+1
	done
done

SRC_URI=""
for i in "${tb34[@]}"; do
	SRC_URI+="http://tablebase.sesse.net/3-4-5/${i}.emd "
done
unset i j m tb34

LICENSE="public-domain" # machine-generated tables
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="5-pieces 6-pieces"
RESTRICT="mirror"				# not on Gentoo mirrors

PDEPEND="5-pieces? ( ~${CATEGORY}/${P}:nofetch )
	6-pieces? ( ~${CATEGORY}/${P}:nofetch[6-pieces] )"

S="${WORKDIR}"

src_unpack() { :; }

src_install() {
	local f
	insinto /usr/share/${PN}
	for f in ${A}; do
		[[ ${f} = *.emd ]] && echo "${DISTDIR}"/${f}
	done | xargs doins
}
