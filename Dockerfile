# NOTE: This is adapted from the official https://github.com/curl/curl-docker/blob/master/alpine/latest/Dockerfile

ARG VERSION=0.0.0
ARG CURL_VERSION="8.2.0"

FROM alpine:3.18.2 AS builder

ARG VERSION

# https://github.com/curl/curl
ARG CURL_VERSION
ENV CURL_VERSION=${CURL_VERSION}

# Install dependencies
RUN set -eux \
    && apk add --no-cache \
        autoconf \
        automake \
        brotli \
        brotli-dev \
        build-base \
        ca-certificates \
        curl \
        curl-dev \
        groff \
        libssh2 \
        libssh2-dev \
        libssh2-static \
        libtool \
        nghttp2 \
        openssl \
        perl \
        python3 \
        python3-dev \
        stunnel \
        tzdata \
        zstd \
        zstd-dev \
    && true

# Get CA cert bundle from curl.haxx.se
RUN set -eux \
    && curl https://curl.haxx.se/ca/cacert.pem -L -o /cacert.pem \
    && true

# Build the tag version
RUN set -eux \
    && mkdir -p /src/curl \
    && ver=$(echo $CURL_VERSION | sed -e 's:\.:_:g') \
    && curl -Lo curl.tar.gz https://github.com/curl/curl/releases/download/curl-${ver}/curl-${CURL_VERSION}.tar.gz \
    && tar xfz curl.tar.gz --strip-components=1 -C /src/curl \
    && true
WORKDIR /src/curl

# Build the tag version
RUN set -eux \
    && autoreconf -vif \
    && ./configure \
        --enable-static \
        --disable-ldap \
        --enable-ipv6 \
        --enable-unix-sockets \
        --with-ssl \
        --with-libssh2 \
        --with-nghttp2=/usr \
        --with-zstd=/usr \
        --prefix=/usr/local \
    && make -j$(nproc) \
    && make DESTDIR="/alpine/" install -j$(nproc) \
    && true

# Deploy Alpine curl image
FROM alpine:3.18.2

LABEL Maintainer="Jose Quintana <joseluisq.net>" \
    Description="Unofficial Curl Alpine Linux."

ARG VERSION
ENV VERSION=${VERSION}

# https://github.com/curl/curl
ARG CURL_VERSION
ENV CURL_VERSION=${CURL_VERSION}

# Install dependencies
RUN set -eux \
    && apk add --no-cache \
        brotli \
        brotli-dev \
        ca-certificates \
        libidn2 \
        libssh2 \
        nghttp2-dev \
        tzdata \
        zstd \
        zstd-dev \
    && rm -fr /var/cache/apk/* \
    && true

# Add non privileged curl user
RUN set -eux \
    && addgroup -S curl_group \
    && adduser -S curl_user -G curl_group \
    && true

# Set curl CA bundle
COPY --from=builder "/cacert.pem" "/cacert.pem"
ENV CURL_CA_BUNDLE="/cacert.pem"

# Install curl built from builder
RUN set -eux \
    && rm -rf /usr/lib/libcurl.so.4 /usr/lib/libcurl.so \
    && true

COPY --from=builder "/alpine/usr/local/lib/libcurl.so.4.8.0" "/usr/lib/"
COPY --from=builder "/alpine/usr/local/bin/curl" "/usr/bin/curl"
COPY --from=builder "/alpine/usr/local/include/curl" "/usr/include/curl"

# Explicit libcurl symlinks
RUN set -eux \
    && ln -s /usr/lib/libcurl.so.4.8.0 /usr/lib/libcurl.so.4 \
    && ln -s /usr/lib/libcurl.so.4 /usr/lib/libcurl.so \
    && true

USER curl_user

COPY "entrypoint.sh" "/entrypoint.sh"
CMD ["curl"]
ENTRYPOINT ["/entrypoint.sh"]

# Metadata
LABEL org.opencontainers.image.vendor="Jose Quintana" \
    org.opencontainers.image.url="https://github.com/joseluisq/alpine-curl" \
    org.opencontainers.image.title="curl" \
    org.opencontainers.image.description="An unofficial cURL Docker image using latest Alpine Linux." \
    org.opencontainers.image.version="${VERSION}" \
    org.opencontainers.image.documentation="https://github.com/joseluisq/alpine-curl"
