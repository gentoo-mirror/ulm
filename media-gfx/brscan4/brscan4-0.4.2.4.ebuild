# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit toolchain-funcs rpm

MY_P="${PN}-${PV%.*}-${PV##*.}"
DESCRIPTION="Brother scanner driver"
HOMEPAGE="http://www.brother.com/"
SRC_URI="
	amd64? ( http://download.brother.com/welcome/dlf006648/${MY_P}.x86_64.rpm )
	x86? ( http://download.brother.com/welcome/dlf006647/${MY_P}.i386.rpm )"

LICENSE="Brother-lpr no-source-code"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="strip"

RDEPEND="media-gfx/sane-backends"

S="${WORKDIR}"

src_install() {
	local lib=$(get_libdir)
	local dest="/opt/brother/scanner/${PN}"

	cp -r opt "${D}" || die

	into ${dest}
	dolib.so usr/lib*/sane/libsane-brother4.so.1.0.7

	dosym {../../..${dest}/${lib},/usr/${lib}/sane}/libsane-brother4.so.1.0.7
	dosym libsane-brother4.so.1.0.7 /usr/${lib}/sane/libsane-brother4.so.1
	dosym libsane-brother4.so.1.0.7 /usr/${lib}/sane/libsane-brother4.so
	dosym {../..${dest},/usr/bin}/brsaneconfig4
	dosym {../../../../..,/etc}${dest}/Brsane4.ini
	dosym {../../../../..,/etc}${dest}/brsanenetdevice4.cfg
	dosym {../../../../..,/etc}${dest}/models4
}
