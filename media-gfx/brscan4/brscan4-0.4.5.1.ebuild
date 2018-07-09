# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib rpm readme.gentoo-r1

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

RDEPEND="media-gfx/sane-backends
	virtual/libusb:0"

S="${WORKDIR}/opt/brother/scanner/${PN}"

src_install() {
	local lib=$(get_libdir)
	local dest=/opt/brother/scanner/${PN}

	insinto /etc${dest}
	doins Brsane4.ini brsanenetdevice4.cfg
	doins -r models4
	dosym "${EPREFIX}"/etc${dest}/Brsane4.ini ${dest}/Brsane4.ini
	dosym "${EPREFIX}"/etc${dest}/brsanenetdevice4.cfg \
		${dest}/brsanenetdevice4.cfg
	dosym "${EPREFIX}"/etc${dest}/models4 ${dest}/models4

	into ${dest}
	dobin brsaneconfig4
	dosym ../..${dest}/bin/brsaneconfig4 /usr/bin/brsaneconfig4

	dolib.so "${WORKDIR}"/usr/lib*/sane/libsane-brother4.so.1.0.7
	dosym libsane-brother4.so.1.0.7 ${dest}/${lib}/libsane-brother4.so.1
	dosym libsane-brother4.so.1.0.7 ${dest}/${lib}/libsane-brother4.so
	dosym ../../..${dest}/${lib}/libsane-brother4.so.1.0.7 \
		/usr/${lib}/sane/libsane-brother4.so.1.0.7
	dosym libsane-brother4.so.1.0.7 /usr/${lib}/sane/libsane-brother4.so.1
	dosym libsane-brother4.so.1.0.7 /usr/${lib}/sane/libsane-brother4.so

	insinto /etc/sane.d/dll.d
	newins - ${PN} <<< "brother4"

	DOC_CONTENTS="If want to use a remote scanner over the network,
		you will have to add it with \"brsaneconfig4\"."
	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
