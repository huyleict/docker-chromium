#!/bin/sh
set -eu

export LANG=${LANG:-C.UTF-8}
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx

mkdir -p "$HOME/.config/openbox"
cp /etc/xdg/openbox/rc.xml "$HOME/.config/openbox/rc.xml"
openbox-session >/dev/null 2>&1 &
sleep 1
exec dbus-run-session -- /usr/local/bin/xorg-session
