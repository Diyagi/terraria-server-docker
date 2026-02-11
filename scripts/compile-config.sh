#!/bin/bash

CONFIG_FILE="${TERRARIA_DIR}/server-config.conf"
TEMPDIR=$(mktemp -d)

update_config() {
  local key="$1"
  local value="$2"
  local found=0

  if [[ -f "$CONFIG_FILE" ]]; then
    while IFS='=' read -r existing_key existing_value; do
      if [[ "$existing_key" = "$key" ]]; then
        if [[ -n "$value" ]]; then
          echo "${key}=${value}" >> "${TEMP_FILE}_${key}"
        fi
        found=1
      else
        echo "${existing_key}=${existing_value}" >> "${TEMP_FILE}_${key}"
      fi
    done < "$CONFIG_FILE"

    if [[ $found -eq 0 ]] && [[ -n "$value" ]]; then
      echo "${key}=${value}" >> "${TEMP_FILE}_${key}"
    fi

    mv "${TEMP_FILE}_${key}" "$CONFIG_FILE"
  else
    echo "${key}=${value}" >> "$CONFIG_FILE"
  fi
}

if [[ -n "$WORLD" ]]; then
  WORLDNAME=$WORLD
  WORLD="${WORLDPATH}/${WORLD// /_}.wld"
fi

update_config "world"       "$WORLD"
update_config "autocreate"  "$AUTOCREATE"
update_config "seed"        "$SEED"
update_config "worldname"   "$WORLDNAME"
update_config "difficulty"  "$DIFFICULTY"
update_config "maxplayers"  "$MAXPLAYERS"
update_config "port"        "$PORT"
update_config "password"    "$PASSWORD"
update_config "motd"        "$MOTD"
update_config "worldpath"   "$WORLDPATH"
update_config "banlist"     "$BANLIST"
update_config "secure"      "$SECURE"
update_config "language"    "$LANGUAGE"
update_config "upnp"        "$UPNP"
update_config "npcstream"   "$NPCSTREAM"
update_config "priority"    "$PRIORITY"


if [[ -n "$TEMPDIR" && -d "$TEMPDIR" ]]; then
  rm -rf -- "$TEMPDIR"
fi
