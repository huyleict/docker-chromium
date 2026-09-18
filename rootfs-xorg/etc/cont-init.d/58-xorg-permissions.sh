#!/bin/sh
set -eu

XRDP_USERNAME=${XRDP_USERNAME:-app}
PROFILE_DIR=/config/chromium-xorg-$XRDP_USERNAME
LOG_DIR=/config/log/chromium-xorg-$XRDP_USERNAME

mkdir -p "$PROFILE_DIR" "$LOG_DIR"
chown -R "$XRDP_USERNAME:$XRDP_USERNAME" "$PROFILE_DIR" "$LOG_DIR"
chmod 700 "$PROFILE_DIR" "$LOG_DIR"
