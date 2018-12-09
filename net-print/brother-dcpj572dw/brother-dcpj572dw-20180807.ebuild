# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit rpm

MODEL="${PN#*-}"
PV_LPR="1.0.5-0"

DESCRIPTION="Brother printer driver for DCP-J572DW"
HOMEPAGE="http://www.brother.com/"
SRC_URI="https://download.brother.com/welcome/dlf103778/${MODEL}pdrv-${PV_LPR}.i386.rpm"

LICENSE="GPL-2+ Brother-lpr no-source-code"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="metric"
RESTRICT="strip"

RDEPEND="net-print/cups"

S="${WORKDIR}/opt/brother/Printers/${MODEL}"

src_prepare() {
	eapply_user
	if use metric; then
		sed -i "/^PaperType/s/Letter/A4/" inf/br${MODEL}rc || die
	fi
}

src_install() {
	local dest=/opt/brother/Printers/${MODEL}

	cd "${S}"/lpd || die
	exeinto ${dest}/lpd
	doexe br${MODEL}filter filter_${MODEL}
	dosym ../../../..${dest}/lpd/filter_${MODEL} \
		/usr/libexec/cups/filter/brother_lpdwrapper_${MODEL}

	cd "${S}"/inf || die
	insinto ${dest}/inf
	doins br${MODEL}func ImagingArea PaperDimension paperinfij2
	doins -r lut
	insinto /etc${dest}/inf
	doins br${MODEL}rc			# config file
	dosym ../../../../../etc${dest}/inf/br${MODEL}rc ${dest}/inf/br${MODEL}rc

	cd "${S}"/cupswrapper || die
	insinto ${dest}/cupswrapper
	doins brother_${MODEL}_printer_en.ppd
	dosym ../../../../..${dest}/cupswrapper/brother_${MODEL}_printer_en.ppd \
		/usr/share/cups/model/Brother/brother_${MODEL}_printer_en.ppd

	# The brprintconf utility is very broken and mangles the path
	# of the function list file. Therefore, don't install it.
	#exeinto ${dest}/bin
	#doexe "${WORKDIR}"/usr/bin/brprintconf_${MODEL}
}
