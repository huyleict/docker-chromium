#!/bin/sh
set -eu

XRDP_USERNAME=${XRDP_USERNAME:-app}
XRDP_PASSWORD=${XRDP_PASSWORD:-${VNC_PASSWORD:-}}
[ -n "$XRDP_PASSWORD" ] || exit 0

if ! id "$XRDP_USERNAME" >/dev/null 2>&1; then
    adduser -D -s /bin/sh "$XRDP_USERNAME"
fi

printf '%s:%s\n' "$XRDP_USERNAME" "$XRDP_PASSWORD" | chpasswd

xrdp-sesman --nodaemon >> /config/log/xrdp-sesman.log 2>&1 &

for _ in 1 2 3 4 5 6 7 8 9 10
do
    [ -S /run/xrdp/sesman.socket ] && break
    sleep 1
done
