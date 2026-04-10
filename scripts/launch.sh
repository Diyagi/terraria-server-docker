#!/bin/bash
source "${SCRIPTSDIR}/helper-functions.sh"

function kill_terrariaserver {
  if [[ -n "${terrariapid:-}" ]] && kill -0 "$terrariapid" 2>/dev/null; then
    LogInfo "Sending shutdown command..."
    echo "exit" >&3
    wait "$terrariapid"
  fi

  if [[ -n "${stdin_forwarder_pid:-}" ]]; then
    kill "$stdin_forwarder_pid" 2>/dev/null
  fi
  return 0
}

trap kill_terrariaserver EXIT

LogAction "Generating Config File"
source "${SCRIPTSDIR}/compile-config.sh"

LogAction "Starting the server..."
architecture=$(dpkg --print-architecture)

# Handles named pipe creation and opening
[ -e /tmp/terraria.stdin ] && rm /tmp/terraria.stdin
mkfifo /tmp/terraria.stdin
exec 3<>/tmp/terraria.stdin

[ "$architecture" == "arm64" ] && SERVER_CMD=(mono --server --gc=sgen -O=all)

$SERVER_CMD "${TERRARIA_DIR}/TerrariaServer.bin.x86_64" -config "${TERRARIA_DIR}/server-config.conf" < /tmp/terraria.stdin > >(tee "${LOGDIR}/terraria.log") &
terrariapid=$!

LogInfo "Started Terraria server with PID ${terrariapid}"

# Redirects this bash's script stdin to Named Piped
if [[ -t 0 ]]; then
    cat </dev/tty >&3 &
    stdin_forwarder_pid=$!
fi

wait $terrariapid
