# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit check-reqs

DESCRIPTION="Syzygy endgame tablebases for up to 6 pieces"
HOMEPAGE="http://tablebase.sesse.net/"

tb345=()
tb6=()
m=(P N B R Q K)
for ((i=4; i>=0; i--)); do
	tb345+=(K${m[i]}vK) # 2+1
	for ((j=i; j>=0; j--)); do
		tb345+=(K${m[i]}vK${m[j]} K${m[i]}${m[j]}vK) # 2+2, 3+1
		for ((k=4; k>=0; k--)); do
			tb345+=(K${m[i]}${m[j]}vK${m[k]}) # 3+2
			((k<=i)) || continue
			for ((l=k; l>=0; l--)); do
				((k<i || l<=j)) && tb6+=(K${m[i]}${m[j]}vK${m[k]}${m[l]}) # 3+3
			done
			((k<=j)) || continue
			tb345+=(K${m[i]}${m[j]}${m[k]}vK) # 4+1
			for ((l=4; l>=0; l--)); do
				tb6+=(K${m[i]}${m[j]}${m[k]}vK${m[l]}) # 4+2
				((l<=k)) && tb6+=(K${m[i]}${m[j]}${m[k]}${m[l]}vK) # 5+1
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
unset i j k l m tb345 tb6

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="tb6"
RESTRICT="mirror"				# not on Gentoo mirrors

S="${WORKDIR}"

pkg_pretend() {
	CHECKREQS_DISK_USR=$(usex tb6 "151G" "939M")
	CHECKREQS_DISK_BUILD="${CHECKREQS_DISK_USR}"
	check-reqs_pkg_pretend
}

pkg_setup() {
	CHECKREQS_DISK_USR=$(usex tb6 "151G" "939M")
	CHECKREQS_DISK_BUILD="${CHECKREQS_DISK_USR}"
	check-reqs_pkg_setup
}

src_unpack() { :; }

src_install() {
	insinto /usr/share/${PN}
	doins "${DISTDIR}"/*.rtbw
	doins "${DISTDIR}"/*.rtbz
	newdoc "${DISTDIR}"/${P}-README README
}
