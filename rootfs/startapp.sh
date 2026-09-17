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

fcitx5 -D --replace >> /config/log/chromium/fcitx5.log 2>&1 &

for _ in 1 2 3 4 5 6 7 8 9 10
do
    fcitx5-remote -s unikey >/dev/null 2>&1 && break
    sleep 1
done

exec /usr/bin/chromium-browser "$@" >> /config/log/chromium/output.log 2>> /config/log/chromium/error.log

# vim:ft=sh:ts=4:sw=4:et:sts=4
