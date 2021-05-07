# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eapi8-dosym rpm

MODEL="${PN#*-}"
PV_LPR="3.0.0-1"
PV_CUPSWRAPPER="3.0.0-1"

DESCRIPTION="Brother printer driver for MFC-J870DW"
HOMEPAGE="http://www.brother.com/"
SRC_URI="http://download.brother.com/welcome/dlf006854/${MODEL}lpr-${PV_LPR}.i386.rpm http://download.brother.com/welcome/dlf006856/${MODEL}cupswrapper-${PV_CUPSWRAPPER}.i386.rpm"
S="${WORKDIR}/opt/brother/Printers/${MODEL}"

LICENSE="GPL-2+ Brother"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="metric"
RESTRICT="strip"

RDEPEND="net-print/cups"

QA_PREBUILT="/opt/brother/*"

src_prepare() {
	default
	if use metric; then
		sed -i "/^PaperType/s/Letter/A4/" inf/br${MODEL}rc || die
	fi
}

src_install() {
	local dest=/opt/brother/Printers/${MODEL}

	cd "${S}"/lpd || die
	exeinto ${dest}/lpd
	doexe br${MODEL}filter filter${MODEL} psconvertij2
	dosym8 -r ${dest}/lpd/filter${MODEL} \
		  /usr/libexec/cups/filter/brother_lpdwrapper_${MODEL}

	cd "${S}"/inf || die
	insinto ${dest}/inf
	doins br${MODEL}func ImagingArea PaperDimension paperinfij2
	doins -r lut
	insinto /etc${dest}/inf
	doins br${MODEL}rc			# config file
	dosym8 -r /etc${dest}/inf/br${MODEL}rc ${dest}/inf/br${MODEL}rc

	cd "${S}"/cupswrapper || die
	insinto ${dest}/cupswrapper
	doins brother_${MODEL}_printer_en.ppd
	dosym8 -r ${dest}/cupswrapper/brother_${MODEL}_printer_en.ppd \
		  /usr/share/cups/model/Brother/brother_${MODEL}_printer_en.ppd

	# The brprintconf utility is very broken and mangles the path
	# of the function list file. Therefore, don't install it.
	#exeinto ${dest}/bin
	#doexe "${WORKDIR}"/usr/bin/brprintconf_${MODEL}
}
