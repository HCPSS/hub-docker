FROM debian:jessie

ENV systemDeps=' \
  git \
  lynx \
  vim \
  wget \
  '

ENV runtimeDeps=' \
  ca-certificates \
  curl \
  bzip2 \
  libapr1 \
  libapr1-dev \
  libaprutil1 \
  libaprutil1-dev \
  libpcre++0 \
  librecode0 \
  libsqlite3-0 \
  libxml2 \
  libssl1.0.0 \
  '

ENV buildDeps=' \
  autoconf \
  file \
  g++ \
  gcc \
  libc-dev \
  libcurl4-openssl-dev \
  libpcre++-dev \
  libreadline6-dev \
  librecode-dev \
  libssl-dev \
  libsqlite3-dev \
  libxml2-dev \
  make \
  pkg-config \
  re2c \
  xz-utils \
  '

ENV GPG_KEYS 0BD78B5F97500D450838F95DFE857D9A90D90EC1 6E4F6AB321FDC07F2C332E3AC2BF0BC433CFC8B3 A93D62ECC3C8EA12DB220EC934EA76E6791485A8
RUN set -xe \
	&& for key in $GPG_KEYS; do \
		gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
	done

# -- Apache prep
ENV HTTPD_VERSION 2.4.17
ENV HTTPD_BZ2_URL https://www.apache.org/dist/httpd/httpd-$HTTPD_VERSION.tar.bz2

ENV HTTPD_PREFIX /usr/local/apache2
ENV PATH $PATH:$HTTPD_PREFIX/bin

RUN mkdir -p "$HTTPD_PREFIX" \
	&& chown www-data:www-data "$HTTPD_PREFIX"
WORKDIR $HTTPD_PREFIX

# -- PHP prep
ENV PHP_VERSION 5.6.16
ENV PHP_FILENAME php-5.6.16.tar.xz
ENV PHP_SHA256 8ef43271d9bd8cc8f8d407d3ba569de9fa14a28985ae97c76085bb50d597de98

ENV PHP_INI_DIR /usr/local/etc/php
RUN mkdir -p $PHP_INI_DIR/conf.d

RUN set -x \
  && apt-get update \
  && apt-get install -y $systemDeps --no-install-recommends \
  && apt-get install -y $runtimeDeps --no-install-recommends \
	&& apt-get install -y $buildDeps --no-install-recommends \
  && curl -SL "$HTTPD_BZ2_URL" -o httpd.tar.bz2 \
	&& curl -SL "$HTTPD_BZ2_URL.asc" -o httpd.tar.bz2.asc \
	&& gpg --verify httpd.tar.bz2.asc \
	&& mkdir -p src/httpd \
	&& tar -xvf httpd.tar.bz2 -C src/httpd --strip-components=1 \
	&& rm httpd.tar.bz2* \
	&& cd src/httpd \
	&& ./configure --enable-so --enable-ssl --prefix=$HTTPD_PREFIX --enable-mods-shared=most \
	&& make -j"$(nproc)" \
	&& make install \
	&& cd ../../ \
	&& rm -r src/httpd \
	&& sed -ri ' \
		s!^(\s*CustomLog)\s+\S+!\1 /proc/self/fd/1!g; \
		s!^(\s*ErrorLog)\s+\S+!\1 /proc/self/fd/2!g; \
		' /usr/local/apache2/conf/httpd.conf \
  && curl -fSL "http://php.net/get/$PHP_FILENAME/from/this/mirror" -o "$PHP_FILENAME" \
  && echo "$PHP_SHA256 *$PHP_FILENAME" | sha256sum -c - \
  && curl -fSL "http://php.net/get/$PHP_FILENAME.asc/from/this/mirror" -o "$PHP_FILENAME.asc" \
  && gpg --verify "$PHP_FILENAME.asc" \
  && mkdir -p /usr/src/php \
  && tar -xf "$PHP_FILENAME" -C /usr/src/php --strip-components=1 \
  && rm "$PHP_FILENAME"* \
  && cd /usr/src/php \
  && ./configure \
    --with-config-file-path="$PHP_INI_DIR" \
    --with-config-file-scan-dir="$PHP_INI_DIR/conf.d" \
    --with-apxs2 \
    --disable-cgi \
    --enable-mysqlnd \
    --with-curl \
    --with-openssl \
    --with-readline \
    --with-recode \
    --with-zlib \
  && make -j"$(nproc)" \
  && make install \
  && apt-get purge -y --auto-remove $buildDeps

EXPOSE 80
