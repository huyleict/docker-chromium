#!/bin/sh
set -eu

export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-/config/.config}
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx

openbox-session >/dev/null 2>&1 &
dbus-run-session -- sh -c '
    fcitx5 -D --replace >/dev/null 2>&1 &
    FCITX_PID=$!
    sleep 2
    CHROMIUM_ARGS="--no-first-run --no-default-browser-check --disable-dev-shm-usage --ignore-gpu-blocklist --start-maximized --user-data-dir=/config/chromium"
    if ! check_pid_namespace >/dev/null 2>&1; then
        CHROMIUM_ARGS="$CHROMIUM_ARGS --no-sandbox"
    fi
    if [ -n "${CHROMIUM_APP_URL:-}" ]; then
        CHROMIUM_ARGS="$CHROMIUM_ARGS --app=$CHROMIUM_APP_URL"
    fi
    if is-bool-val-true "${CHROMIUM_REMOTE_DEBUGGING:-0}"; then
        CHROMIUM_ARGS="$CHROMIUM_ARGS --remote-debugging-port=$((${CHROMIUM_REMOTE_DEBUGGING_PORT:-9222} + 1))"
    fi
    if [ -n "${CHROMIUM_CUSTOM_ARGS:-}" ]; then
        CHROMIUM_ARGS="$CHROMIUM_ARGS $CHROMIUM_CUSTOM_ARGS"
    fi
    eval "exec /usr/bin/chromium-browser $CHROMIUM_ARGS" &
    CHROMIUM_PID=$!
    sleep 1
    FCITX_ENV=$(tr "\0" "\n" < /proc/$FCITX_PID/environ 2>/dev/null |
        grep -E "^(DBUS_SESSION_BUS_ADDRESS|DISPLAY|XDG_RUNTIME_DIR)=" || true)
    eval "$(printf "%s\n" "$FCITX_ENV" | sed "s/^/export /")"
    fcitx5-remote -s unikey >/dev/null 2>&1 || true
    wait "$CHROMIUM_PID"
' -- "$@"
