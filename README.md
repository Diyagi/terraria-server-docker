


# Terraria Server Docker

[![Release](https://img.shields.io/github/v/release/Diyagi/terraria-server-docker)](https://github.com/Diyagi/terraria-server-docker/releases)
[![Docker Pulls](https://img.shields.io/docker/pulls/diyagi/terraria-server-docker)](https://hub.docker.com/r/diyagi/terraria-server-docker)
[![Image Size](https://img.shields.io/docker/image-size/diyagi/terraria-server-docker/latest)](https://hub.docker.com/r/diyagi/terraria-server-docker/tags)
[![Docker Hub](https://img.shields.io/badge/Docker_Hub-Terraria-blue?logo=docker)](https://hub.docker.com/r/diyagi/terraria-server-docker)

A heavily refactored fork of the original image focused on security and flexibility. The container runs the server as a non-root user, supports configurable PUID/PGID, downloads server files at runtime, and uses a custom-maintained ARM64 base image instead of the original discontinued one.


## Getting Started

Follow this [docker-compose.yml](/docker-compose.yml) example and check [environment variables](#container-environment-variables) below for more information.

```yaml
services: 
  terraria-server:
    image: diyagi/terraria-server-docker:latest
    container_name: terraria-server
    restart: unless-stopped
    stdin_open: true
    tty: true
    ports:
      - 7777:7777
    volumes:
      # Server config can be mounted and edited to include journey mode permissions
      #- ./server-config.conf:/home/terraria/server-files/server-config.conf
      - ./worlds:/home/terraria/worlds
    environment:
      PUID: 1000
      PGID: 1000
      PORT: 7777
      VERSION: "latest"
      WORLD: "My Little Test World"
      AUTOCREATE: 2
      DIFFICULTY: 2
      MAXPLAYERS: 4
      PASSWORD: ""
      MOTD: "BEAR!"
      SECURE: 0
      NPCSTREAM: 0
```

## Container Environment Variables

| Variable | Type/Default | Description |
| :------- | -----------| :----------- |
| `PUID` | `1000` | UID used by the container to run the server as. |
| `PGID` | `1000` | GID used by the container to run the server as. |
| `VERSION` | `"latest"` | Target Terraria server version to be downloaded and used, accepts SemVer standard (ex: 1.4.5.5).|
| `PORT` | `7777` | Terraria server port. |
| `MAXPLAYERS` | `16` | Max players that can join the server at same time |
| `MOTD` | `"Welcome!"` | Message of the day, message thats shown in chat when a player joins the game. |
| `PASSWORD` | `""` | Server password. |
| `WORLD` | `""` | World Name. |
| `AUTOCREATE` | `1` | Creates a new world if none is found. World size is specified by: 1(small), 2(medium), and 3(large). |
| `BANLIST` | `"banlist.txt"` | The location of the banlist. Defaults to "banlist.txt" in the working directory. |
| `SECURE` | `1` | Adds additional cheat protection. |
| `UPNP` | `0` | Automatically forward ports with uPNP. |
| `DIFFICULTY` | `1` | Sets world difficulty when using -autocreate. Options: 0(normal), 1(expert), 2(master), 3(journey) |
| `NPCSTREAM` | `0` | Reduces enemy skipping but increases bandwidth usage. The lower the number the less skipping will happen, but more data is sent. 0 is off. |
|`LANGUAGE` | `"en-US"` | Sets the server language from its language code. Available codes: `en-US`-English; `de-DE`-German; `it-IT`-Italian; `fr-FR`-French; `es-ES`-Spanish; `ru-RU`-Russian; `zh-Hans`-Chinese; `pt-BR`-Portuguese; `pl-PL`-Polish; |
| `PRIORITY` | `1` | Default system priority 0:Realtime, 1:High, 2:AboveNormal, 3:Normal, 4:BelowNormal, 5:Idle |
| `SEED` | `""` | Sets the world seed when using autocreate. |
