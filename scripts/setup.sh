#!/bin/bash
source "${SCRIPTSDIR}/helper-functions.sh"

get_latest_terraria_version() {
  curl -s "https://terraria.org/api/get/dedicated-servers-names" \
    | jq -r '.[0]' \
    | sed 's/^terraria-server-\(.*\)\.zip$/\1/'
}

download_terraria_server() {
  local terraria_version="$1"

  if [[ -z "$terraria_version" ]]; then
    LogError "Version not specified"
    exit 1
  elif [[ ! "$terraria_version" =~ ^[0-9]+(\.[0-9]+)*$ ]]; then
    LogError "Invalid version format: $input_version"
    LogError "Expected numeric or semver-like version (e.g. 1454 or 1.4.5.4)"
    exit 1
  fi

  raw_version="${terraria_version//./}"

  LogAction "Installing Terraria Server"
  LogInfo "Version: ${terraria_version}"

  cd "$TERRARIA_DIR"

  url="https://terraria.org/api/download/pc-dedicated-server/terraria-server-${raw_version}.zip"

  LogInfo "Downloading from: $url"
  if ! curl -fLsS "$url" -o terraria-server.zip; then
    LogError "Failed to download Terraria server version ${input_version}"
    LogError "The version may not exist or the server returned an error."
    rm -f terraria-server.zip
    exit 1
  fi

  tmpdir="$(mktemp -d)"
  unzip -qq terraria-server.zip "*/Linux/*" -d "$tmpdir"
  rsync -a "$tmpdir"/*/Linux/ "$TERRARIA_DIR/"
  rm -rf "$tmpdir"

  if [[ "$(dpkg --print-architecture)" == "arm64" ]]; then
    rm -f \
      "${TERRARIA_DIR}"/System* \
      "${TERRARIA_DIR}"/Mono* \
      "${TERRARIA_DIR}/monoconfig" \
      "${TERRARIA_DIR}/mscorlib.dll"
  fi

  chmod +x "$TERRARIA_DIR/TerrariaServer.bin.x86_64"

  LogInfo "Server install finished."
}

if [[ "$VERSION" == "latest" ]]; then
  VERSION="$(get_latest_terraria_version)"
fi

download_terraria_server "$VERSION"

exec bash "${SCRIPTSDIR}/launch.sh"
