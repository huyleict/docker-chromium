#!/bin/sh

set -eu

XRDP_USERNAME=${XRDP_USERNAME:-abc}
XRDP_PASSWORD=${XRDP_PASSWORD:-${VNC_PASSWORD:-}}
[ -n "$XRDP_PASSWORD" ] || exit 0

if ! id "$XRDP_USERNAME" >/dev/null 2>&1; then
    adduser -D -s /bin/sh "$XRDP_USERNAME"
fi

printf '%s:%s\n' "$XRDP_USERNAME" "$XRDP_PASSWORD" | chpasswd

for XRDP_FILE in /etc/xrdp/rsakeys.ini /etc/xrdp/cert.pem /etc/xrdp/key.pem
do
    [ -f "$XRDP_FILE" ] && chmod 644 "$XRDP_FILE"
done
