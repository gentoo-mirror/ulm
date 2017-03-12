# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit check-reqs

DESCRIPTION="Nalimov chess endgame tablebases for up to 6 pieces"
HOMEPAGE="http://tablebase.sesse.net/
	http://kirill-kryukov.com/chess/tablebases-online/"

tb5=()
tb6=()
m=(p n b r q k)
for ((i=4; i>=0; i--)); do
	for ((j=i; j>=0; j--)); do
		for ((k=4; k>=0; k--)); do
			tb5+=(k${m[i]}${m[j]}k${m[k]}.nb{w,b}) # 3+2
			((k<=i)) || continue
			for ((l=k; l>=0; l--)); do
				((k<i || l<=j)) || continue
				tb6+=(k${m[i]}${m[j]}k${m[k]}${m[l]}.nbw) # 3+3
				((k!=i || l!=j)) && tb6+=(k${m[i]}${m[j]}k${m[k]}${m[l]}.nbb)
			done
			((k<=j)) || continue
			tb5+=(k${m[i]}${m[j]}${m[k]}k.nb{w,b}) # 4+1
			for ((l=4; l>=0; l--)); do
				tb6+=(k${m[i]}${m[j]}${m[k]}k${m[l]}.nb{w,b}) # 4+2
			done
		done
	done
done

# table of (number of files -1) for each 6-pieces set, in the same order
# as the list was created above
nfiles=([7]=3 3 [25]=3 3 [35]=3 4 [41]=3 3 [51]=3 4 [55]=3 3 [65]=3 4
	[69]=3 3 3 4 3 4 3 4 2 3 [84]=15 14 [92]=7 7 [102]=3 4 [108]=7 7
	[118]=7 8 [122]=7 7 [132]=7 8 3 2 14 15 7 8 7 8 7 8 5 6 [149]=15 14
	[153]=2 2 2 2 7 7 [163]=7 7 [173]=3 4 [177]=7 7 2 2 [187]=7 8 3 2
	14 15 7 8 7 8 7 8 11 12 0 15 14 [206]=2 2 2 2 7 7 [216]=7 7 [220]=7 7
	[230]=3 4 5 5 14 15 7 8 7 8 7 8 11 12 11 7 8 14 16 7 7 5 6 3 4 7 7
	5 6 3 3 5 6 4 4 5 6 2 3 2 3 2 3 4 4 [280]=4 3 [296]=4 3 [306]=4 4
	[310]=8 7 [320]=3 4 [324]=7 7 3 4 3 4 3 4 6 6 [337]=8 7 [341]=2 2 8 7
	[353]=4 4 [357]=16 15 [367]=7 8 6 5 15 15 7 8 7 8 7 8 12 12 0 7 7
	[386]=5 5 15 15 [392]=15 15 [402]=3 4 6 5 14 15 7 8 7 8 7 8 11 12 6
	7 8 15 15 12 12 7 7 12 12 4 4 5 6 2 3 2 3 2 3 4 4 [442]=4 3 [456]=8 7
	[466]=3 4 [470]=7 7 7 8 3 4 3 4 6 6 0 7 7 [485]=15 15 [495]=3 4 6 5
	15 15 15 16 7 8 7 8 12 12 6 7 7 12 12 4 4 5 6 5 6 2 3 2 3 4 4 0 7 7
	[541]=3 3 3 4 3 4 3 4 2 3 6 4 4 5 6 2 3 2 3 2 3 4 4)
tb6n=()
s=({0..9} {a..z})
for ((i=0; i<${#tb6[@]}; i++)); do
	if ((nfiles[i]==0)); then
		tb6n+=(${tb6[i]})
	else
		for j in ${s[@]:0:nfiles[i]+1}; do
			tb6n+=(${tb6[i]/./.${j}.})
		done
	fi
done

SRC_URI="${tb5[@]/%/.emd} 6-pieces? ( ${tb6n[@]/%/.emd} )"
unset i j k l m nfiles s tb5 tb6 tb6n

LICENSE="public-domain" # machine-generated tables
SLOT="nofetch"
KEYWORDS="~amd64 ~x86"
IUSE="6-pieces"
RESTRICT="fetch"

RDEPEND="~${CATEGORY}/${P}:0"

S="${WORKDIR}"

pkg_pretend() {
	CHECKREQS_DISK_USR=$(usex 6-pieces "1150G" "7200M")
	CHECKREQS_DISK_BUILD="${CHECKREQS_DISK_USR}"
	check-reqs_pkg_pretend
}

pkg_setup() {
	CHECKREQS_DISK_USR=$(usex 6-pieces "1150G" "7200M")
	CHECKREQS_DISK_BUILD="${CHECKREQS_DISK_USR}"
	check-reqs_pkg_setup
}

pkg_nofetch() {
	einfo "Due to their large size, fetching the Nalimov Endgame Tablebases"
	einfo "via file sharing is recommended:"
	einfo "http://kirill-kryukov.com/chess/tablebases-online/"
	einfo "After fetching, place all k*.emd files in ${DISTDIR}."
	einfo
	einfo "Total number and size of files should be as follows:"
	einfo "   3, 4 pieces:    70 files    30 MiB"
	einfo "   5 pieces:      220 files  7200 MiB"
	einfo "   6 pieces:     2512 files  1147 GiB"
	einfo "   Total:        2802 files  1154 GiB"
}

src_unpack() { :; }

src_install() {
	local f
	insinto /usr/share/${PN}
	for f in ${A}; do
		[[ ${f} = *.emd ]] && echo "${DISTDIR}"/${f}
	done | xargs doins
}
