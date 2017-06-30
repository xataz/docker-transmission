FROM xataz/alpine:3.6

LABEL description="transmission based on alpine" \
      tags="latest" \
      maintainer="xataz <https://github.com/xataz>" \
      build_ver="2017062902"

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
ARG MEDIAINFO_VER=0.7.95
ARG LIBZEN_VER=0.4.31

ENV FILEBOT_RENAME_METHOD="symlink" \
    FILEBOT_RENAME_MOVIES="{n} ({y})" \
    FILEBOT_RENAME_SERIES="{n}/Season {s.pad(2)}/{s00e00} - {t}" \
    FILEBOT_RENAME_ANIMES="{n}/{e.pad(3)} - {t}" \
    FILEBOT_RENAME_MUSICS="{n}/{fn}"

RUN if [ "${WITH_FILEBOT}" == "YES" ]; then \
        apk add --no-cache openjdk8-jre java-jna-native binutils wget build-base automake autoconf libtool \
        && cd /tmp \
        && wget http://mediaarea.net/download/binary/mediainfo/${MEDIAINFO_VER}/MediaInfo_CLI_${MEDIAINFO_VER}_GNU_FromSource.tar.gz \
        && wget http://mediaarea.net/download/binary/libmediainfo0/${MEDIAINFO_VER}/MediaInfo_DLL_${MEDIAINFO_VER}_GNU_FromSource.tar.gz \
        && wget http://downloads.sourceforge.net/zenlib/libzen_${LIBZEN_VER}.tar.gz \
        && tar xzf libzen_${LIBZEN_VER}.tar.gz \
        && tar xzf MediaInfo_DLL_${MEDIAINFO_VER}_GNU_FromSource.tar.gz \
        && tar xzf MediaInfo_CLI_${MEDIAINFO_VER}_GNU_FromSource.tar.gz \
        && cd /tmp/ZenLib/Project/GNU/Library \
        && ./autogen \
        && ./configure --prefix=/usr/local \
                        --enable-shared \
                        --disable-static \
        && make && make install \
        && cd  /tmp/MediaInfo_DLL_GNU_FromSource \
        && ./SO_Compile.sh \
        && cd /tmp/MediaInfo_DLL_GNU_FromSource/ZenLib/Project/GNU/Library \
        && make install \
        && cd /tmp/MediaInfo_DLL_GNU_FromSource/MediaInfoLib/Project/GNU/Library \
        && make install \
        && cd /tmp/MediaInfo_CLI_GNU_FromSource \
        && ./CLI_Compile.sh \
        && cd /tmp/MediaInfo_CLI_GNU_FromSource/MediaInfo/Project/GNU/CLI \
        && make install \
        && strip -s /usr/local/bin/mediainfo \
        && mkdir /filebot \
        && cd /filebot \
        && wget http://downloads.sourceforge.net/project/filebot/filebot/FileBot_${FILEBOT_VER}/FileBot_${FILEBOT_VER}-portable.tar.xz -O /filebot/filebot.tar.xz \
        && tar xJf filebot.tar.xz \
        && apk del ca-certificates libressl \
        && mv chromaprint-fpcalc-${CHROMAPRINT_VER}-linux-x86_64/fpcalc /usr/local/bin \
        && strip -s /usr/local/bin/fpcalc \
        && ln -sf /usr/local/lib/libzen.so.0.0.0 /filebot/lib/x86_64/libzen.so \
        && ln -sf /usr/local/lib/libmediainfo.so.0.0.0 /filebot/lib/x86_64/libmediainfo.so \
        && apk del --no-cache wget binutils build-base automake autoconf libtool \
        && rm -rf /filebot/FileBot_${FILEBOT_VER}-portable.tar.xz \
    ;fi

VOLUME ["/data","/home/transmission/.config/transmission-daemon/"]
COPY rootfs /
RUN chmod +x /usr/local/bin/startup
EXPOSE 9091

ENTRYPOINT ["/usr/local/bin/startup"]
CMD ["transmission-daemon", "--foreground"]
