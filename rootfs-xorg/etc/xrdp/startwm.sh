#!/bin/sh
set -eu

export HOME=/config
export DISPLAY="${DISPLAY:-:${XRDP_DISPLAY:-10}}"
export XAUTHORITY="${XAUTHORITY:-/config/.Xauthority}"
export XDG_CONFIG_HOME=/config/.config
export LANG=${LANG:-C.UTF-8}
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx

openbox-session >/dev/null 2>&1 &
exec dbus-run-session -- /usr/local/bin/xorg-session
