#!/bin/sh
#
# NOTE: Parameters to pass to Chromium are defined via the `params` file of the
#       app service.
#

set -e
set -u

rm -rf /config/chromium/Singleton*

fcitx5 -D --replace >> /config/log/chromium/fcitx5.log 2>&1 &

exec /usr/bin/chromium-browser "$@" >> /config/log/chromium/output.log 2>> /config/log/chromium/error.log

# vim:ft=sh:ts=4:sw=4:et:sts=4
