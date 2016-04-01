# $FreeBSD$

PORTNAME=	zoneminder
PORTVERSION=	1.29.0
DISTVERSION = ecb8c48
CATEGORIES=	multimedia

MAINTAINER=	foo@bar
COMMENT=	Complete security camera solution, fully web based with image analysis

LICENSE=	GPLv2

USE_GITHUB=	yes
GH_ACCOUNT=	FriendsOfCake:crud
GH_PROJECT=	crud:crud
GH_TAGNAME=	c3976f1:crud

WRKSRC= ${WRKDIR}/ZoneMinder-${DISTVERSION}

BUILD_DEPENDS=	p5-DBI>=0:${PORTSDIR}/databases/p5-DBI \
				p5-DBD-mysql>=0:${PORTSDIR}/databases/p5-DBD-mysql \
				p5-Date-Manip>=0:${PORTSDIR}/devel/p5-Date-Manip \
				p5-Test-LWP-UserAgent>=0:${PORTSDIR}/www/p5-Test-LWP-UserAgent \
				p5-Sys-Mmap>=0:${PORTSDIR}/devel/p5-Sys-Mmap \
				p5-LWP-Protocol-https>=0:${PORTSDIR}/www/p5-LWP-Protocol-https
LIB_DEPENDS=	libpolkit-gobject-1.so:${PORTSDIR}/sysutils/polkit
RUN_DEPENDS=	${BUILD_DEPENDS}

USES=		cmake jpeg perl5 shebangfix
USE_MYSQL= yes

PLIST_SUB= WWWOWN="${WWWOWN}" WWWGRP="${WWWGRP}"

SHEBANG_FILES=	scripts/zmaudit.pl.in \
				scripts/zmcamtool.pl.in \
				scripts/zmcontrol.pl.in \
				scripts/zmdc.pl.in \
				scripts/zmfilter.pl.in \
				scripts/zmpkg.pl.in \
				scripts/zmsystemctl.pl.in \
				scripts/zmtelemetry.pl.in \
				scripts/zmtrack.pl.in \
				scripts/zmtrigger.pl.in \
				scripts/zmupdate.pl.in \
				scripts/zmvideo.pl.in \
				scripts/zmwatch.pl.in \
				scripts/zmx10.pl.in

CMAKE_ARGS+=	-DZM_PERL_MM_PARMS=INSTALLDIRS=site \
				-DZM_CONFIG_DIR=/usr/local/etc \
				-DZM_WEBDIR=${WWWDIR} \
				-DZM_CGIDIR=${WWWDIR}/cgi-bin \
				-DZM_CONTENTDIR=${WWWDIR}
#CMAKE_ARGS+=	-DCMAKE_VERBOSE_MAKEFILE=ON

post-extract:
	@${MV} ${WRKSRC_crud}/* ${WRKSRC}/web/api/app/Plugin/Crud

post-install:
	${CP} ${STAGEDIR}${PREFIX}/etc/zm.conf ${STAGEDIR}${PREFIX}/etc/zm.conf.sample
	${MKDIR} ${STAGEDIR}${WWWDIR}/images
	${MKDIR} ${STAGEDIR}${WWWDIR}/events
	${MKDIR} ${STAGEDIR}/var/run/zm
	${MKDIR} ${STAGEDIR}/var/tmp/zm
	
.include <bsd.port.mk>
