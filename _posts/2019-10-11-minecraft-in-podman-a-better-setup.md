---
title: Minecraft in Podman - A Better Setup
date: 2019-10-11T15:47:00+09:30
author: James Young
layout: post
categories:
  - Gaming
tags:
  - linux
  - podman
  - minecraft
---

After a fair bit of mucking about, I think I've come up with a fairly modular way to put together a Minecraft server in Podman.  Obviously this script makes quite a few assumptions, so you'll need to make some changes;

* Set `ROOT` to where you're going to place your instance.
* If you are using a distro without SELinux, remove the `,Z` and `restorecon` bits.
* Set `TZ` to your timezone.
* Remove the `.nobackup` bits if they aren't relevant to you.
* Adjust the `POD_UID` and `POD_GID` if relevant.

Here's the startup script;

```bash
#!/bin/bash

# Set this to the root of this instance
# Also set server port and uid/gid as required
ROOT=/srv/ddss
PORT=25565
POD_UID=10025565
POD_GID=10025565

# Ensure permissions are correctly set for all the folders
for x in instance world backups config mods; do
  # Make sure the directory exists and set permissions
  mkdir -p $ROOT/$x
  chown -R $POD_UID:$POD_GID $ROOT/$x
  restorecon -R $ROOT/$x
done

# Generate exclusion files for the backups and logs folders
touch $ROOT/backups/.nobackup
mkdir -p $ROOT/instance/FeedTheBeast/logs
touch $ROOT/instance/FeedTheBeast/logs/.nobackup

# Run up the container
podman run -it --name ddss \
  --volume $ROOT/instance:/data:rw,slave,Z \
  --volume $ROOT/config:/config:rw,slave,Z \
  --volume $ROOT/mods:/mods:rw,slave,Z \
  --volume $ROOT/world:/data/FeedTheBeast/world:rw,slave,Z \
  --volume $ROOT/backups:/data/FeedTheBeast/backups:rw,slave,Z \
  --publish $PORT:$PORT \
  --cpus=4 \
  --cpu-shares=2048 \
  --memory=10g \
  --memory-reservation=4g \
  --restart=on-failure:3 \
  --env-file /srv/podman/ddss/variables.env \
  -e UID=$POD_UID \
  -e GID=$POD_GID \
  -e INIT_MEMORY=4G \
  -e MAX_MEMORY=8G \
  -e JVM_DD_OPTS='sun.rmi.dgc.server.gcInterval:2147483646' \
  -e JVM_XX_OPTS='+UnlockExperimentalVMOptions +UseG1GC G1NewSizePercent:20 MaxGCPauseMillis:50 G1HeapRegionSize:32M' \
  -e TZ='Australia/Adelaide' \
  -e CF_SERVER_MOD='DDSS+Serverfiles+6.2.zip' \
  -e SERVER_PORT=$PORT \
  itzg/minecraft-server:latest
```

And here is the `variables.env`, which specifies various settings to go into `server.properties`.

```bash
VERSION=1.12.2
EULA=TRUE
TYPE=CURSEFORGE
FORCE_REDOWNLOAD=false
OVERRIDE_SERVER_PROPERTIES=true
LEVEL=world
SERVER_NAME=DDSS
MOTD=Set this to your MOTD!
SNOOPER_ENABLED=false
MAX_TICK_TIME=-1
VIEW_DISTANCE=10
DIFFICULTY=normal
MODE=survival
PVP=false
ALLOW_FLIGHT=TRUE
FORCE_GAMEMODE=true
HARDCORE=false
ALLOW_NETHER=true
ANNOUNCE_PLAYER_ACHIEVEMENTS=true
ENABLE_COMMAND_BLOCK=true
GENERATE_STRUCTURES=true
MAX_BUILD_HEIGHT=256
SPAWN_ANIMALS=true
SPAWN_MONSTERS=true
SPAWN_NPCS=true
```

Now, once that's done, you will have an instance setup which looks like this;

```
+--- /srv/ddss
     |--- instance
     |--- config
     |--- mods
     |--- world
     |--- backups
```

* `instance` is the folder where your ZIP will be extracted and the instance assembled.  Put your install zip inside there.
* `config` is config overrides for the instance.  In theory they gets copied into the config directory, but you may need to do this yourself after the instance is started the first time.
* `mods` is mod overrides for the instance.  Same thing applies to this as with `config`.
* `world` is the save for your generated world.  Obviously this is quite precious.
* `backups` is any backups made by something like AromaBackup.  You don't need this if you don't have AromaBackup in your instance (DDSS does).

## Creating a brand new instance

So you want to use this from scratch?  Pretty easy.

1. Create an `instance` folder inside `/srv/ddss` in this case.  Drop the downloaded server package ZIP for the modpack you're using, then tune `variables.env` and other parameters to suit.
2. Run up the instance.  Once it's up, exit it.
3. Make any changes you needed to, like copying in config/mods etc.  You should have your initial world waiting for you in `world`.

## Updating an instance that already exists

Updating is also fairly straightforward;

1. Stop the instance and remove the container.
2. Move the instance folder elsewhere
3. Create a new instance folder and put the downloaded server package ZIP into it.
4. Edit your `run.sh` and put in the new ame of the modpack (if any).
5. Start the instance.

Good luck!