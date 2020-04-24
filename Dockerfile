FROM haproxy:2.1-alpine

RUN apk --no-cache add openssl

COPY haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg
COPY docker-entrypoint.sh /
