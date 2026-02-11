#!/bin/bash
source "${SCRIPTSDIR}/helper-functions.sh"

function kill_terrariaserver {
  if [[ -n "${terrariapid:-}" ]] && kill -0 "$terrariapid" 2>/dev/null; then
    LogInfo "Sending shutdown command..."
    echo "exit" >&3
    wait "$terrariapid"
  fi
  return 0
}

trap kill_terrariaserver EXIT

LogAction "Generating Config File"
source "${SCRIPTSDIR}/compile-config.sh"

LogAction "Starting the server..."
architecture=$(dpkg --print-architecture)

# Handles named pipe creation and opening
if [ -e "/tmp/terraria.stdin" ]; then rm /tmp/terraria.stdin; fi
mkfifo /tmp/terraria.stdin
exec 3<>/tmp/terraria.stdin

if [ "$architecture" == "arm64" ]; then
  mono --server --gc=sgen -O=all ${TERRARIA_DIR}/TerrariaServer.exe -config ${TERRARIA_DIR}/server-config.conf < /tmp/terraria.stdin &
else
  ${TERRARIA_DIR}/TerrariaServer.bin.x86_64 -config ${TERRARIA_DIR}/server-config.conf < /tmp/terraria.stdin &
fi

terrariapid=$!
LogInfo "Started Terraria server with PID ${terrariapid}"

# Redirects this bash's script stdin to Named Piped
if [[ -t 0 ]]; then
    cat </dev/tty >&3 &
    stdin_forwarder_pid=$!
fi

wait $terrariapid

