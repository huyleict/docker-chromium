#!/bin/sh
#
# NOTE: Parameters to pass to Chromium are defined via the `params` file of the
#       app service.
#

set -e
set -u

rm -rf /config/chromium/Singleton*

while ! awk 'NR > 1 && ($2 ~ /:0D3D|:170C/) && $4 == "01" {found=1} END {exit !found}' /proc/net/tcp /proc/net/tcp6 2>/dev/null
do
    sleep 1
done

if is-bool-val-true "${CHROMIUM_DEBUG:-0}"; then
    FCITX_LOG=/config/log/chromium/fcitx5.log
    CHROMIUM_OUTPUT_LOG=/config/log/chromium/output.log
    CHROMIUM_ERROR_LOG=/config/log/chromium/error.log
else
    FCITX_LOG=/dev/null
    CHROMIUM_OUTPUT_LOG=/dev/null
    CHROMIUM_ERROR_LOG=/dev/null
fi

fcitx5 -D --replace >> "$FCITX_LOG" 2>&1 &

/usr/bin/chromium-browser "$@" >> "$CHROMIUM_OUTPUT_LOG" 2>> "$CHROMIUM_ERROR_LOG" &
CHROMIUM_PID=$!

sleep 1
kill -0 "$CHROMIUM_PID" 2>/dev/null || wait "$CHROMIUM_PID"

for _ in 1 2 3 4 5 6 7 8 9 10
do
    FCITX_ENV=$(tr "\0" "\n" < /proc/$(pgrep -o fcitx5)/environ 2>/dev/null |
        grep -E "^(DBUS_SESSION_BUS_ADDRESS|DISPLAY|XDG_RUNTIME_DIR)=" || true)
    eval "$(printf "%s\n" "$FCITX_ENV" | sed "s/^/export /")"
    fcitx5-remote -s unikey >/dev/null 2>&1 && break
    sleep 1
done

wait "$CHROMIUM_PID"

# vim:ft=sh:ts=4:sw=4:et:sts=4
