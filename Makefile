# $FreeBSD$

PORTNAME=	zoneminder
PORTVERSION=	1.29.1.a.20160420
DISTVERSION =	5a3978f
CATEGORIES=	multimedia

MAINTAINER=	foo@bar
COMMENT=	Complete security camera solution, fully web based with image analysis

LICENSE=	GPLv2

RUN_DEPENDS=	p5-DBI>=0:${PORTSDIR}/databases/p5-DBI \
		p5-DBD-mysql>=0:${PORTSDIR}/databases/p5-DBD-mysql \
		p5-Date-Manip>=0:${PORTSDIR}/devel/p5-Date-Manip \
		p5-Test-LWP-UserAgent>=0:${PORTSDIR}/www/p5-Test-LWP-UserAgent \
		p5-Sys-Mmap>=0:${PORTSDIR}/devel/p5-Sys-Mmap \
		p5-LWP-Protocol-https>=0:${PORTSDIR}/www/p5-LWP-Protocol-https \
		p5-Sys-CPU>=0:${PORTSDIR}/devel/p5-Sys-Cpu \
		p5-Sys-MemInfo>=0:${PORTSDIR}/devel/p5-Sys-MemInfo \
		ffmpeg>=2.0:${PORTSDIR}/multimedia/ffmpeg

USE_GITHUB=	yes
GH_ACCOUNT=	FriendsOfCake:crud
GH_PROJECT=	crud:crud
GH_TAGNAME=	c3976f1:crud

WRKSRC=		${WRKDIR}/ZoneMinder-${DISTVERSION}

USES=		cmake jpeg perl5 shebangfix
USE_MYSQL=	yes
USE_RC_SUBR=	zoneminder
IGNORE_WITH_PHP=    70

OPTIONS_DEFINE=	NLS
OPTIONS_SUB=	yes
NLS_USES=	gettext
NLS_CONFIGURE_ENABLE=	nls

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
		-DZM_CONFIG_DIR=${PREFIX}/etc \
		-DZM_WEBDIR=${WWWDIR} \
		-DZM_CGIDIR=${WWWDIR}/cgi-bin \
		-DZM_CONTENTDIR=${WWWDIR}
#CMAKE_ARGS+=	-DCMAKE_VERBOSE_MAKEFILE=ON

post-extract:
	@${MV} ${WRKSRC_crud}/* ${WRKSRC}/web/api/app/Plugin/Crud

pre-install:
	${INSTALL_DATA} ${STAGEDIR}${PREFIX}/etc/zm.conf ${STAGEDIR}${PREFIX}/etc/zm.conf.sample
	${MKDIR} ${STAGEDIR}${WWWDIR}/images
	${MKDIR} ${STAGEDIR}${WWWDIR}/events
	${MKDIR} ${STAGEDIR}/var/run/zm
	${MKDIR} ${STAGEDIR}/var/tmp/zm

.include <bsd.port.mk>
