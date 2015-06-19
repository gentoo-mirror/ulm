# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

EGIT_REPO_URI="git://git.savannah.gnu.org/gnulib.git
	http://git.savannah.gnu.org/r/gnulib.git"

inherit git-r3

DESCRIPTION="Git merge driver for GNU style ChangeLog files"
HOMEPAGE="http://www.gnu.org/software/gnulib/"

LICENSE="GPL-3+"
SLOT="0"

src_prepare() {
	S="${WORKDIR}/${PN}"
	./gnulib-tool --create-testdir --without-tests --dir="${S}" ${PN} || die
	cd "${S}"
	sed -n '/README/{h;:x;n;/^#/!{H;bx};g;s/\n*$//;s:/usr/local:/usr:g;p;q}' \
		gllib/git-merge-changelog.c >README || die
}
