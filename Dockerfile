FROM sdhibit/alpine-runit:3.6
MAINTAINER Steve Hibit <sdhibit@gmail.com>

ARG PKG_NAME="caddy"
ARG PKG_VER="0.10.6"
ARG APP_BASEURL="https://github.com/mholt/caddy/releases/download"
ARG APP_PKGNAME="v${PKG_VER}/${PKG_NAME}_v${PKG_VER}_linux_amd64.tar.gz"
ARG APP_URL="${APP_BASEURL}/${APP_PKGNAME}"

ENV CADDYPATH /config/assets

RUN apk --update upgrade \
 && apk add --no-cache \
    ca-certificates \
    libcap \
    tar \
    xz \
 && mkdir /tmp/caddy \
 && curl -kL ${APP_URL} | tar -xz -C /tmp/caddy \
 && mv /tmp/caddy/caddy /usr/local/bin \
 && setcap cap_net_bind_service=+ep /usr/local/bin/caddy \
 && chmod 0755 /usr/local/bin/caddy \
 && update-ca-certificates

# Create user and change ownership
RUN mkdir -p /config \
 && addgroup -g 666 -S caddy \
 && adduser -u 666 -SHG caddy caddy \
 && chown -R caddy:caddy \
    "/srv" \
    "/config"

VOLUME ["/config", "/srv"]

COPY Caddyfile /config/Caddyfile
COPY index.html /srv/index.html

EXPOSE 80 443 2015

WORKDIR /srv

# Add services to runit
ADD caddy.sh /etc/service/caddy/run
RUN chmod +x /etc/service/*/run