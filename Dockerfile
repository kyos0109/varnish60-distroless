FROM debian:9.5-slim

# https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
ARG TIME_ZONE

RUN apt-get update && \
	apt-get install curl libcap-dev -y && \
	curl -s https://packagecloud.io/install/repositories/varnishcache/varnish60/script.deb.sh | bash && \
	apt-get update && \
	apt-get install varnish -y && \
	apt-get clean autoclean && \
	apt-get autoremove --yes && \
	rm -rf /var/lib/{apt,dpkg,cache,log}/

RUN mkdir -p /opt/etc && mkdir -p /opt/var/lib/varnish && \
    cp /usr/share/zoneinfo/${TIME_ZONE:-ROC} /opt/etc/localtime && \
    cp -a /lib/terminfo/x /usr/share/terminfo/x && \
    cp -a --parents /usr/bin/varnish* /opt && \
    cp -aL --parents /usr/bin/gcc* /opt && \
    cp -aL --parents /usr/bin/as /opt && \
    cp -aL --parents /usr/bin/ld /opt && \
    cp -a --parents /usr/lib/libvarnishapi.so.* /opt && \
    cp -a --parents /usr/lib/x86_64-linux-gnu/libjemalloc.so.* /opt && \
    cp -a --parents /usr/lib/x86_64-linux-gnu/libmpfr.so.* /opt && \
    cp -a --parents /usr/lib/x86_64-linux-gnu/libgmp.so.* /opt && \
    cp -a --parents /usr/lib/x86_64-linux-gnu/libedit.so.* /opt && \
    cp -a --parents /usr/lib/x86_64-linux-gnu/libopcodes-* /opt && \
    cp -a --parents /usr/lib/x86_64-linux-gnu/libbfd-* /opt && \
    cp -a --parents /usr/lib/x86_64-linux-gnu/crt* /opt && \
    cp -a --parents /usr/lib/x86_64-linux-gnu/libpthread* /opt && \
    cp -a --parents /usr/lib/x86_64-linux-gnu/libc* /opt && \
    cp -a --parents /usr/lib/x86_64-linux-gnu/libcidn.so /opt && \
    cp -a --parents /usr/lib/x86_64-linux-gnu/libgomp.so.* /opt && \
    cp -a --parents /usr/lib/x86_64-linux-gnu/libisl.so.* /opt && \
    cp -a --parents /usr/lib/x86_64-linux-gnu/libmpc.so.* /opt && \
    cp -a --parents /usr/include /opt && \
    cp -a --parents /usr/lib/gcc /opt && \
    cp -a --parents /lib/x86_64-linux-gnu/libbz2.so.* /opt && \
    cp -a --parents /lib/x86_64-linux-gnu/libcap.so.* /opt && \
    cp -a --parents /lib/x86_64-linux-gnu/libpcre.so.* /opt && \
    cp -a --parents /lib/x86_64-linux-gnu/libz.so.* /opt && \
    cp -a --parents /lib/x86_64-linux-gnu/libncurses.so.* /opt && \
    cp -a --parents /lib/x86_64-linux-gnu/libtinfo.so.* /opt && \
    cp -a --parents /lib/x86_64-linux-gnu/libncursesw.so.* /opt && \
    cp -a --parents /lib/x86_64-linux-gnu/libuuid* /opt && \
    cp -a --parents /lib/x86_64-linux-gnu/libgcc_s* /opt && \
    cp -a --parents /lib/x86_64-linux-gnu/libbsd.so.* /opt && \
    cp -a --parents /usr/lib/varnish /opt && \
    cp -a --parents /usr/sbin/varnishd /opt && \
    cp -a --parents /bin/rm /opt && \
    cp -a --parents /usr/share/terminfo/x /opt && \
    cp -a --parents /etc/varnish /opt

FROM gcr.io/distroless/base

COPY --from=0 /opt /
COPY --from=0 /bin/sh /bin/sh

ENTRYPOINT [ "varnishd", "-F" ]

CMD [ "-h" ]
