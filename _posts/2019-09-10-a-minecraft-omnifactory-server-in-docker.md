---
title: A Minecraft Omnifactory Server in Docker
date: 2019-09-10T19:07:34+09:30
author: James Young
layout: post
permalink: /2019/10/a-minecraft-omnifactory-server-in-docker/
categories:
  - Gaming
tags:
  - docker
---

I recently discovered [OmniFactory](https://www.curseforge.com/minecraft/modpacks/omnifactory) for Minecraft, and this gave me a renewed interest in Minecraft in general.  It's a very deep modpack, which incorporates a lot of machinery, chemistry, and focuses on crafting.  This means it's also horrendously complicated, but comes with interesting problem solving and design gameplay, which is something I like.

Notably though, OmniFactory has some pretty lengthy processes.  You may start up a smelting job that takes some time to run, and therefore it can be an advantage to run your own server at home so those jobs can run while you're off doing something else.  A Docker container is a perfect place for this sort of thing to run.

Fortunately, someone's already made a pretty great Minecraft docker container.  So you can just go and get it from [Docker Hub](https://hub.docker.com/r/itzg/minecraft-server/) and then use Docker Compose like this;

```yaml
version: '2'

services:
  omnifactory:
    image: itzg/minecraft-server:latest
    restart: unless-stopped
    mem_limit: 5gb
    mem_reservation: 4gb
    environment:
      # JVM Setup Values
      INIT_MEMORY: 4G
      MAX_MEMORY: 4G
      JVM_DD_OPTS: sun.rmi.dgc.server.gcInterval=2147483646
      JVM_XX_OPTS: +UnlockExperimentalVMOptions +UseG1GC G1NewSizePercent=20 MaxGCPauseMillis=50 G1HeapRegionSize=32M

      # Basic modpack setup
      VERSION: "1.12.2"
      EULA: "TRUE"
      TYPE: "CURSEFORGE"
      CF_SERVER_MOD: "https://www.curseforge.com/minecraft/modpacks/omnifactory/download/2733486"
      FORCE_REDOWNLOAD: "false"

      # Customize server properties below
      OVERRIDE_SERVER_PROPERTIES: "true"

      # Set server name and essentials
      SERVER_NAME: "OmniFactory Home"
      SERVER_PORT: 25565
      MOTD: "An OmniFactory Server"
      LEVEL: "OmniFactory"
      SNOOPER_ENABLED: "false"
      MAX_TICK_TIME: 60000
      VIEW_DISTANCE: 10
      OPS: "YourPlayerNameHere"

      # Gamemode settings
      DIFFICULTY: "peaceful"
      MODE: "survival"
      PVP: "false"
      ALLOW_FLIGHT: "TRUE"
      FORCE_GAMEMODE: "true"
      HARDCORE: "false"
      ALLOW_NETHER: "true"
      ANNOUNCE_PLAYER_ACHIEVEMENTS: "true"
      ENABLE_COMMAND_BLOCK: "true"

      # World generation settings
      LEVEL_TYPE: "lostcities"
      GENERATOR_SETTINGS: '{"Topography-Preset"\:"Omnifactory"}'
      GENERATE_STRUCTURES: "true"
      MAX_BUILD_HEIGHT: 256
      SPAWN_ANIMALS: "true"
      SPAWN_MONSTERS: "true"
      SPAWN_NPCS: "true"

    tty: true
    stdin_open: true
    ports:
      - 25565:25565
    volumes:
      - /mnt/data:/data:rw,Z
```

Customize to taste.  Notably, the memory settings.  You have to set a memory limit that's higher than the Java heap, because the heap is in addition to code space, and if you set them the same value your container will get killed.  Hence why it's 5Gb.  Also, I set the minimum and maximum heap the same value because that discourages the JVM garbage collector from being overly aggressive and therefore causing lag spikes.  Unfortunately OmniFactory is quite memory hungry.

Other than that, it should just pretty well work.  You need to have ENABLE_FLIGHT on, because otherwise grapple hooks and Angel Rings won't work.