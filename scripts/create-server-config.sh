#!/bin/bash

file="${TERRARIA_DIR}/server-config.conf"
touch ${file}
echo > ${file}

# user has set the world variable and the world exists. Loads world
if [[ ! -z "${WORLD}" && -f "${WORLD}" ]]; then
    LogInfo "${file}: Loading world: ${WORLD}"
    echo "world=${WORLD}" >> ${file}

# user has set the world variable but it doesnt exists. Creates it. This will bypass the worldname variable.
elif [[ ! -z "${WORLD}" && ! -f "${WORLD}" ]]; then
    LogInfo "${file}: World ${WORLD} doesn't exists. Creating it using:"

    echo "worldname: $(basename "${WORLD}")"
    echo "autocreate: ${AUTOCREATE}"
    echo "seed: ${SEED}"
    echo "difficulty: ${DIFFICULTY}"

    echo "world=${WORLD}" >> ${file}
    echo "autocreate=${AUTOCREATE}" >> ${file}
    echo "seed=${SEED}" >> ${file}
    echo "worldname=$(basename "${WORLD}")" >> ${file}
    echo "difficulty=${DIFFICULTY}" >> ${file}

# user has not set the world variable.
else
    echo "world=${WORLDPATH}/${WORLDNAME}.wld" >> ${file}
    echo "autocreate=${AUTOCREATE}" >> ${file}
    echo "seed=${SEED}" >> ${file}
    echo "worldname=${WORLDNAME}" >> ${file}
    echo "difficulty=${DIFFICULTY}" >> ${file}
fi

echo "maxplayers=${MAXPLAYERS}" >> ${file}
echo "port=${PORT}" >> ${file}
echo "password=${PASSWORD}" >> ${file}
echo "motd=${MOTD}" >> ${file}
echo "worldpath=${WORLDPATH}" >> ${file}

[[ -n "${BANLIST:-}" && ! -f "${TERRARIA_DIR}/$BANLIST" ]] && touch "${TERRARIA_DIR}/$BANLIST"

echo "banlist=${BANLIST}" >> ${file}

echo "secure=${SECURE}" >> ${file}
echo "language=${LANGUAGE}" >> ${file}
echo "upnp=${UPNP}" >> ${file}
echo "npcstream=${NPCSTREAM}" >> ${file}
echo "priority=${PRIORITY}" >> ${file}

