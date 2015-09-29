# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit check-reqs

DESCRIPTION="Syzygy endgame tablebases for up to 6 pieces"
HOMEPAGE="http://tablebase.sesse.net/"

pc=(Q R B N P)
tb345=()
tb6=()
for ((i=0; i<5; i++)); do
	tb345+=(K${pc[i]}vK) # 2+1
	for ((j=i; j<5; j++)); do
		tb345+=(K${pc[i]}vK${pc[j]} K${pc[i]}${pc[j]}vK) # 2+2, 3+1
		for ((k=0; k<5; k++)); do
			tb345+=(K${pc[i]}${pc[j]}vK${pc[k]}) # 3+2
			((k>=j)) && tb345+=(K${pc[i]}${pc[j]}${pc[k]}vK) # 4+1
			for ((l=0; l<5; l++)); do
				if ((k>=i && l>=k)) && ((k>i || l>=j)); then
					tb6+=(K${pc[i]}${pc[j]}vK${pc[k]}${pc[l]}) # 3+3
				fi
				if ((k>=j)); then
					tb6+=(K${pc[i]}${pc[j]}${pc[k]}vK${pc[l]}) # 4+2
					((l>=k)) && tb6+=(K${pc[i]}${pc[j]}${pc[k]}${pc[l]}vK) # 5+1
				fi
			done
		done
	done
done

SRC_URI="http://tablebase.sesse.net/README -> ${P}-README"
for i in "${tb345[@]}"; do
	SRC_URI+=" http://tablebase.sesse.net/syzygy/3-4-5/${i}.rtbw"
	SRC_URI+=" http://tablebase.sesse.net/syzygy/3-4-5/${i}.rtbz"
done
SRC_URI+=" tb6? ("
for i in "${tb6[@]}"; do
	SRC_URI+=" http://tablebase.sesse.net/syzygy/6-WDL/${i}.rtbw"
	SRC_URI+=" http://tablebase.sesse.net/syzygy/6-DTZ/${i}.rtbz"
done
SRC_URI+=" )"
unset i j k l pc tb345 tb6

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="tb6"
RESTRICT="mirror"				# not on Gentoo mirrors

S="${WORKDIR}"

CHECKREQS_DISK_USR="151G"
CHECKREQS_DISK_BUILD="${CHECKREQS_DISK_USR}"

pkg_pretend() {
	use tb6 && check-reqs_pkg_pretend
}

pkg_setup() {
	use tb6 && check-reqs_pkg_setup
}

src_unpack() { :; }

src_install() {
	insinto /usr/share/games/${PN}
	doins "${DISTDIR}"/*.rtbw
	doins "${DISTDIR}"/*.rtbz
	newdoc "${DISTDIR}"/${P}-README README
}
