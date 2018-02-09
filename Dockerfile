FROM xataz/alpine:3.7

LABEL description="transmission based on alpine" \
      tags="latest" \
      maintainer="xataz <https://github.com/xataz>" \
      build_ver="2018020501"

ENV UID=991 \
    GID=991 \
    WEBROOT=""

RUN BUILD_DEPS="git" \
    && apk add --no-cache transmission-daemon \
                su-exec \
                tini \
                ca-certificates \
                libressl \
                ${BUILD_DEPS} \
    && apk del --no-cache ${BUILD_DEPS}

ARG WITH_FILEBOT=NO
ARG FILEBOT_VER=4.7.9
ARG CHROMAPRINT_VER=1.4.2

ENV FILEBOT_RENAME_METHOD="symlink" \
    FILEBOT_RENAME_MOVIES="{n} ({y})" \
    FILEBOT_RENAME_SERIES="{n}/Season {s.pad(2)}/{s00e00} - {t}" \
    FILEBOT_RENAME_ANIMES="{n}/{e.pad(3)} - {t}" \
    FILEBOT_RENAME_MUSICS="{n}/{fn}"

RUN if [ "${WITH_FILEBOT}" == "YES" ]; then \
        apk add --no-cache openjdk8-jre java-jna-native mediainfo libmediainfo wget ca-certificates \
        && wget https://github.com/acoustid/chromaprint/releases/download/v${CHROMAPRINT_VER}/chromaprint-fpcalc-${CHROMAPRINT_VER}-linux-x86_64.tar.gz \
        && tar xzf chromaprint-fpcalc-${CHROMAPRINT_VER}-linux-x86_64.tar.gz \
        && mkdir /filebot \
        && wget http://downloads.sourceforge.net/project/filebot/filebot/FileBot_${FILEBOT_VER}/FileBot_${FILEBOT_VER}-portable.tar.xz -O /filebot/filebot.tar.xz \
        && cd /filebot \
        && tar xJf filebot.tar.xz \
        && mv /tmp/chromaprint-fpcalc-${CHROMAPRINT_VER}-linux-x86_64/fpcalc /usr/local/bin \
        && strip -s /usr/local/bin/fpcalc \
        && apk del --no-cache wget ca-certificates \
        && rm -rf /filebot/FileBot_${FILEBOT_VER}-portable.tar.xz /tmp/* \
    ;fi

VOLUME ["/data","/home/transmission/.config/transmission-daemon/"]
COPY rootfs /
RUN chmod +x /usr/local/bin/startup
EXPOSE 9091

ENTRYPOINT ["/usr/local/bin/startup"]
CMD ["transmission-daemon", "--foreground"]
