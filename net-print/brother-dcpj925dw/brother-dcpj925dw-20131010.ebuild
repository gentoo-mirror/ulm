# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit rpm

MODEL="${PN#*-}"
PV_LPR="3.0.1-1"
PV_CUPSWRAPPER="3.0.0-1"

DESCRIPTION="Brother printer driver for DCP-J925DW"
HOMEPAGE="http://www.brother.com/"
SRC_URI="http://download.brother.com/welcome/dlf005614/${MODEL}lpr-${PV_LPR}.i386.rpm http://download.brother.com/welcome/dlf005616/${MODEL}cupswrapper-${PV_CUPSWRAPPER}.i386.rpm"

LICENSE="GPL-2+ Brother-lpr no-source-code"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="metric"
RESTRICT="strip"

RDEPEND="net-print/cups"

S="${WORKDIR}"

src_prepare() {
	if use metric; then
		sed -i "/^PaperType/s/Letter/A4/" \
			opt/brother/Printers/${MODEL}/inf/br${MODEL}rc || die
	fi
}

src_install() {
	cp -r opt "${D}" || die

	exeinto /opt/brother/Printers/${MODEL}/bin
	doexe usr/bin/brprintconf_${MODEL}

	dosym ../../../../opt/brother/Printers/${MODEL}/lpd/filter${MODEL} \
		  /usr/libexec/cups/filter/brother_lpdwrapper_${MODEL}
	dosym ../../../../opt/brother/Printers/${MODEL}/cupswrapper/brother_${MODEL}_printer_en.ppd \
		  /usr/share/cups/model/brother_${MODEL}_printer_en.ppd
	dosym ../../opt/brother/Printers/${MODEL}/bin/brprintconf_${MODEL} \
		  /usr/sbin/brprintconf_${MODEL}
}
