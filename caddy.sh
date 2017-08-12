#! /bin/sh

mkdir -p $CADDYPATH
chown -R caddy:caddy $CADDYPATH

# Start Caddy
/sbin/su-exec caddy /usr/local/bin/caddy \
	-conf /config/Caddyfile \
	-log stdout