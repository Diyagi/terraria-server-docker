FROM debian:trixie-slim AS base-amd64
FROM --platform=arm64 diyagi/mono-framework-docker:latest AS base-arm64

ARG TARGETARCH
FROM base-${TARGETARCH}

ENV USER=terraria
ENV HOMEDIR="/home/${USER}/"
ENV TERRARIA_VERSION=$VERSION
ENV TERRARIA_DIR="${HOMEDIR}/terraria"
ENV WORLDS_DIR="${HOMEDIR}/worlds"
ENV SCRIPTSDIR="${HOMEDIR}/scripts"

RUN apt-get update && apt-get install -y --no-install-recommends \ 
	ca-certificates \
	locales \
	python3 \
	unzip \
	curl \
	tini \
	gosu \
    && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && dpkg-reconfigure --frontend=noninteractive locales \
    && useradd -u 1000 -m "${USER}" \
    && rm -rf /var/lib/apt/lists/*

COPY ./scripts/* ${SCRIPTSDIR}
RUN set -x \
    && chmod +x -R ${SCRIPTSDIR} \
    && mkdir -p ${TERRARIA_DIR} \
    && mkdir -p ${WORLDS_DIR} \
    && chown -R "${USER}:${USER}" "${SCRIPTSDIR}" "${TERRARIA_DIR}" "${WORLDS_DIR}"

ENV PUID=1000 \
    PGID=1000 \
    VERSION="latest" \
    AUTOCREATE=1 \
    SEED="" \
    WORLDNAME="TerrariaWorld" \
    DIFFICULTY=1 \
    MAXPLAYERS=16 \
    PORT=7777 \
    PASSWORD="" \
    MOTD="Welcome!" \
    WORLDPATH="${WORLDS_DIR}" \
    BANLIST="banlist.txt" \
    SECURE=1 \
    LANGUAGE="en/US" \
    UPNP=1 \
    NPCSTREAM=1 \
    PRIORITY=1

WORKDIR ${HOMEDIR}

ENTRYPOINT ["/usr/bin/tini", "--"]

CMD [ "bash", "init.sh" ]

### arm-64 ###

#FROM diyagi/mono-framework-docker:latest AS build-arm64

#RUN chmod +x TerrariaServer.exe

#RUN rm System* Mono* monoconfig mscorlib.dll

# Use tini as the entrypoint for signal handling
#ENTRYPOINT ["/usr/bin/tini", "--"]

#cmd [ "bash", "init-TerrariaServer-arm64.sh" ]
