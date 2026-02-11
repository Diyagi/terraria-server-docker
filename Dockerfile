FROM debian:trixie-slim AS base-amd64
FROM --platform=arm64 diyagi/mono-framework-docker:latest AS base-arm64

ARG TARGETARCH
FROM base-${TARGETARCH}

ENV USER=terraria
ENV HOMEDIR="/home/${USER}"
ENV TERRARIA_DIR="${HOMEDIR}/server-files"
ENV WORLDS_DIR="${HOMEDIR}/worlds"
ENV SCRIPTSDIR="${HOMEDIR}/scripts"

RUN apt-get update && apt-get install -y --no-install-recommends \ 
	ca-certificates \
	locales \
	unzip \
	curl \
	tini \
	gosu \
	jq \
    && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && dpkg-reconfigure --frontend=noninteractive locales \
    && useradd -u 1000 -m "${USER}" \
    && rm -rf /var/lib/apt/lists/*

COPY ./scripts ${SCRIPTSDIR}
RUN set -x \
    && chmod +x -R ${SCRIPTSDIR} \
    && mkdir -p ${TERRARIA_DIR} \
    && mkdir -p ${WORLDS_DIR} \
    && chown -R "${USER}:${USER}" "${SCRIPTSDIR}" "${TERRARIA_DIR}" "${WORLDS_DIR}"

ENV PUID=1000 \
    PGID=1000 \
    VERSION="latest" \
    WORLDPATH="${WORLDS_DIR}" \
    PORT=7777 \
    MAXPLAYERS=16 \
    MOTD="Welcome!" \
    PASSWORD="" \
    WORLD="" \
    AUTOCREATE=1 \
    BANLIST="banlist.txt" \
    SECURE=1 \
    UPNP=0 \
    DIFFICULTY=1 \
    NPCSTREAM=0 \
    LANGUAGE="en-US" \
    PRIORITY=1 \
    SEED="" 

WORKDIR ${HOMEDIR}

ENTRYPOINT ["/usr/bin/tini", "--"]

CMD [ "bash", "scripts/init.sh" ]

