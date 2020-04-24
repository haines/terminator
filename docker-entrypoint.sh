#!/bin/sh
set -o errexit
set -o nounset
set -o pipefail

if [[ -z "${CERTIFICATE_CHAIN_PATH:-}" ]]; then
  CERTIFICATE_CHAIN_PATH=/usr/local/etc/haproxy/ssl/terminator.pem

  mkdir -p /usr/local/etc/haproxy/ssl

  openssl req \
    -x509 \
    -out /usr/local/etc/haproxy/ssl/terminator.crt \
    -keyout /usr/local/etc/haproxy/ssl/terminator.key \
    -newkey rsa:2048 \
    -nodes \
    -sha256 \
    -subj "/CN=${CERTIFICATE_COMMON_NAME:-localhost}" \
    2>/dev/null

  cat \
    /usr/local/etc/haproxy/ssl/terminator.crt \
    /usr/local/etc/haproxy/ssl/terminator.key \
    >/usr/local/etc/haproxy/ssl/terminator.pem
fi

sed -i'' \
    -e s%'${BACKEND_ADDRESS}'%"${BACKEND_ADDRESS}"%g \
    -e s%'${CERTIFICATE_CHAIN_PATH}'%"${CERTIFICATE_CHAIN_PATH}"%g \
    /usr/local/etc/haproxy/haproxy.cfg

exec "$@"
