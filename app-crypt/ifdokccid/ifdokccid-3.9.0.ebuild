# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit toolchain-funcs udev

DESCRIPTION="Omnikey CardMan 3x21 PC/SC CCID driver"
HOMEPAGE="http://www.hidglobal.com/drivers"
SRC_URI="amd64? ( ${PN}_lnx_x64-${PV}.tar.gz )
	x86? ( ${PN}_lnx_i686-${PV}.tar.gz )"

LICENSE="HID_OK_Drivers_EULA"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
RESTRICT="fetch bindist"

RDEPEND="sys-apps/pcsc-lite
	virtual/libusb:1"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

pkg_nofetch() {
	einfo "Please download ${A}"
	einfo "from ${HOMEPAGE}"
	einfo "and place it in ${DISTDIR}"
}

pkg_setup() {
	MY_P="${PN}_lnx_$(usex amd64 x64 i686)-${PV}"
	S="${WORKDIR}/${MY_P}"
}

src_install () {
	insinto "$("$(tc-getPKG_CONFIG)" --variable=usbdropdir libpcsclite)"
	doins -r "${MY_P}.bundle"
	udev_dorules "${FILESDIR}"/92-pcsc-${PN}.rules
	dodoc README
}
