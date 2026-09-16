#!/bin/sh

set -eu

mkdir -p /config/.config/fcitx5/conf

cat > /config/.config/fcitx5/conf/unikey.conf <<'CONF'
[General]
InputMethod=UkTelex
OutputCharset=XUTF8
CONF
cat > /config/.config/fcitx5/profile <<'PROFILE'
[Groups/0]
Name=Default
Default Layout=us
DefaultIM=unikey

[Groups/0/Items/0]
Name=keyboard-us
Layout=

[Groups/0/Items/1]
Name=unikey
Layout=

[GroupOrder]
0=Default
PROFILE
