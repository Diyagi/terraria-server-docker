#!/bin/bash
source "${SCRIPTSDIR}/helper-functions.sh"

function kill_terrariaserver {
  if [[ -n "${terrariapid:-}" ]] && kill -0 "$terrariapid" 2>/dev/null; then
    LogInfo "Sending shutdown command..."
    echo "exit" > /tmp/terraria.stdin
    wait "$terrariapid"
  fi
}

trap kill_terrariaserver EXIT

LogAction "Generating Config File"
source "${SCRIPTSDIR}/create-server-config.sh"

LogAction "Starting the server..."

architecture=$(dpkg --print-architecture)

if [ -f /tmp/terraria.stdin ]; then rm /tmp/terraria.stdin; fi
mkfifo /tmp/terraria.stdin
exec 3<>/tmp/terraria.stdin

if [ "$architecture" == "arm64" ]; then
  mono --server --gc=sgen -O=all ${TERRARIA_DIR}/TerrariaServer.exe -config server-config.conf < /tmp/terraria.stdin &
else
  ${TERRARIA_DIR}/TerrariaServer.bin.x86_64 -config server-config.conf < /tmp/terraria.stdin &
fi

terrariapid=$!

LogInfo "Started Terraria server with PID ${terrariapid}"
wait $terrariapid

