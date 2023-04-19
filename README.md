# Alpine cURL [![devel](https://github.com/joseluisq/alpine-curl/actions/workflows/devel.yml/badge.svg)](https://github.com/joseluisq/alpine-curl/actions/workflows/devel.yml) [![Docker Image Version (tag latest semver)](https://img.shields.io/docker/v/joseluisq/alpine-curl/latest)](https://hub.docker.com/r/joseluisq/alpine-curl/) [![Docker Image Size (tag)](https://img.shields.io/docker/image-size/joseluisq/alpine-curl/latest)](https://hub.docker.com/r/joseluisq/alpine-curl/tags) [![Docker Image](https://img.shields.io/docker/pulls/joseluisq/alpine-curl.svg)](https://hub.docker.com/r/joseluisq/alpine-curl/)

> An unofficial [Curl](https://github.com/curl/curl) Docker image using latest [Alpine Linux](https://www.alpinelinux.org/).
>

**Note:** This Docker image exists to help test [static-web-server](https://github.com/static-web-server/static-web-server) using [Zstandard](http://facebook.github.io/zstd/). If you are looking for the official one, please then visit https://github.com/curl/curl-docker

## Usage

For example, print out curl release version, protocols and features.

```sh
docker run --rm joseluisq/alpine-curl curl --version
# curl 8.0.1 (aarch64-unknown-linux-musl) libcurl/8.0.1 OpenSSL/1.1.1t zlib/1.2.12 brotli/1.0.9 zstd/1.5.2 libssh2/1.10.0 nghttp2/1.47.0
# Release-Date: 2023-03-20
# Protocols: dict file ftp ftps gopher gophers http https imap imaps mqtt pop3 pop3s rtsp scp sftp smb smbs smtp smtps telnet tftp
# Features: alt-svc AsynchDNS brotli HSTS HTTP2 HTTPS-proxy IPv6 Largefile libz NTLM NTLM_WB SSL threadsafe TLS-SRP UnixSockets zstd
```

Or perform a request. For instance, using the latest [Zstandard](http://facebook.github.io/zstd/) compression algorithm.

Note the `accept-encoding` and `content-encoding` headers below.

```sh
docker run --rm joseluisq/alpine-curl \
    curl -I -H "accept-encoding: zstd" https://www.facebook.com

# HTTP/2 200
# vary: Accept-Encoding
# content-encoding: zstd
# document-policy: force-load-at-top
# cross-origin-opener-policy: same-origin-allow-popups
# pragma: no-cache
# cache-control: private, no-cache, no-store, must-revalidate
# expires: Sat, 01 Jan 2000 00:00:00 GMT
# x-content-type-options: nosniff
# x-xss-protection: 0
# x-frame-options: DENY
# strict-transport-security: max-age=15552000; preload
# content-type: text/html; charset="utf-8"
# date: Wed, 19 Apr 2023 21:30:24 GMT
# alt-svc: h3=":443"; ma=8640
```

## Dockerfile

You can also use the image as a base for your Dockerfile:

```Dockerfile
FROM joseluisq/alpine-curl
```

## Contributions

Unless you explicitly state otherwise, any contribution you intentionally submitted for inclusion in current work, as defined in the Apache-2.0 license, shall be dual licensed as described below, without any additional terms or conditions.

Feel free to submit a [pull request](https://github.com/joseluisq/alpine-curl/pulls) or file an [issue](https://github.com/joseluisq/alpine-curl/issues).

## License

This work is primarily distributed under the terms of both the [MIT license](LICENSE-MIT) and the [Apache License (Version 2.0)](LICENSE-APACHE).

© 2023-present [Jose Quintana](https://joseluisq.net)
