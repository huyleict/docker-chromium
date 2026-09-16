#!/bin/sh

set -eu

mkdir -p /config/.config/fcitx5
if [ ! -f /config/.config/fcitx5/profile ]; then
    cat > /config/.config/fcitx5/profile <<'PROFILE'
[Groups/0]
Name=Default
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
fi
