# $FreeBSD$

PORTNAME=	zoneminder
PORTVERSION=	1.29.1.a.20160426
DISTVERSION =	ff3e9c8
CATEGORIES=	multimedia

MAINTAINER=	foo@bar
COMMENT=	Complete security camera solution, fully web based with image analysis

LICENSE=	GPLv2

ZM_DEPENDS=	p5-DBI>=0:databases/p5-DBI \
		p5-DBD-mysql>=0:databases/p5-DBD-mysql \
		p5-Date-Manip>=0:devel/p5-Date-Manip \
		p5-Test-LWP-UserAgent>=0:www/p5-Test-LWP-UserAgent \
		p5-Sys-Mmap>=0:devel/p5-Sys-Mmap \
		p5-LWP-Protocol-https>=0:www/p5-LWP-Protocol-https \
		p5-Sys-CPU>=0:devel/p5-Sys-Cpu \
		p5-Sys-MemInfo>=0:devel/p5-Sys-MemInfo \
		ffmpeg:multimedia/ffmpeg
BUILD_DEPENDS=	${ZM_DEPENDS}
RUN_DEPENDS=	${ZM_DEPENDS} \
		sudo:security/sudo

USE_GITHUB=	yes
GH_ACCOUNT=	FriendsOfCake:crud
GH_PROJECT=	crud:crud
GH_TAGNAME=	c3976f1:crud

WRKSRC=		${WRKDIR}/ZoneMinder-${DISTVERSION}

USES=		cmake jpeg perl5 shebangfix
USE_MYSQL=	yes
USE_RC_SUBR=	zoneminder
PHP=		pdo_mysql session
IGNORE_WITH_PHP=    70

OPTIONS_DEFINE=	NLS V4L DOCS
OPTIONS_SUB=	yes
NLS_USES=	gettext
NLS_CONFIGURE_ENABLE=	nls
V4L_BUILD_DEPENDS=	${LOCALBASE}/include/linux/videodev2.h:multimedia/v4l_compat
V4L_LIB_DEPENDS=	libv4l2.so:multimedia/libv4l
OPTIONS_DEFAULT=	NLS

PLIST_SUB= WWWOWN="${WWWOWN}" WWWGRP="${WWWGRP}"

SHEBANG_FILES=	scripts/zmaudit.pl.in \
		scripts/zmcamtool.pl.in \
		scripts/zmcontrol.pl.in \
		scripts/zmdc.pl.in \
		scripts/zmfilter.pl.in \
		scripts/zmpkg.pl.in \
		scripts/zmtelemetry.pl.in \
		scripts/zmtrack.pl.in \
		scripts/zmtrigger.pl.in \
		scripts/zmupdate.pl.in \
		scripts/zmvideo.pl.in \
		scripts/zmwatch.pl.in \
		scripts/zmx10.pl.in \
		onvif/scripts/zmonvif-probe.pl

PORTDOCS=	AUTHORS BUGS ChangeLog INSTALL NEWS README.FreeBSD TODO

CMAKE_ARGS+=	-DZM_PERL_MM_PARMS=INSTALLDIRS=site \
		-DZM_CONFIG_DIR=${PREFIX}/etc \
		-DZM_WEBDIR=${WWWDIR} \
		-DZM_CGIDIR=${WWWDIR}/cgi-bin \
		-DZM_CONTENTDIR=${WWWDIR} \
		-DHAVE_SENDFILE=0 \
		-DCMAKE_REQUIRED_INCLUDES:STRING="${LOCALBASE}/include"
#CMAKE_ARGS+=	-DCMAKE_VERBOSE_MAKEFILE=ON

post-extract:
	${MV} ${WRKSRC_crud}/* ${WRKSRC}/web/api/app/Plugin/Crud
	${CP} ${FILESDIR}/README.FreeBSD ${WRKSRC}
	${REINPLACE_CMD} -e 's,/dev/shm,/tmp,g' ${WRKSRC}/scripts/ZoneMinder/lib/ZoneMinder/ConfigData.pm.in

pre-install:
	${MKDIR} ${STAGEDIR}${WWWDIR}/images
	${MKDIR} ${STAGEDIR}${WWWDIR}/events
	${MKDIR} ${STAGEDIR}/var/run/zm
	${MKDIR} ${STAGEDIR}/var/tmp/zm

post-install:
	${INSTALL_DATA} ${STAGEDIR}${PREFIX}/etc/zm.conf ${STAGEDIR}${PREFIX}/etc/zm.conf.sample

post-install-DOCS-on:
	${MKDIR} ${STAGEDIR}${DOCSDIR}
	cd ${WRKSRC} && ${INSTALL_DATA} ${PORTDOCS} ${STAGEDIR}${DOCSDIR}

.include <bsd.port.mk>
