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
* Set `MIN_RAM` and `MAX_RAM` as required.
* If you are using a distro without SELinux, remove the `,Z` and `restorecon` bits.
* Set `TZ` to your timezone.
* Remove the `.nobackup` bits if they aren't relevant to you.
* Adjust the `POD_UID` and `POD_GID` if relevant.
* Change the `PUBLISH` if required to specify an IP.
* Set your `MOTD` and `OPS` as needed.

We duplicate up a bunch of environmental variables because different packs use different options for setting the JVM up.  Sorry about that.

Here's the startup script;

```bash
#!/bin/bash

########## Configuration ##########

# Set this to the root of this instance
# Also set server port and uid/gid as required
ROOT=/srv/podman/atm3r
PORT=25567
POD_UID=10025567
POD_GID=10025567
PUBLISH="$PORT:$PORT"

# Set these to the heap settings
# The set used by this pack by default seems good, so we'll use it here too.
MIN_RAM=3G
MAX_RAM=6G
JAVA_ARGS="-d64 -server -Xms$MIN_RAM -Xmx$MAX_RAM -XX:+AggressiveOpts -XX:ParallelGCThreads=3 -XX:+UseConcMarkSweepGC -XX:+UnlockExperimentalVMOptions -XX:+UseParNewGC -XX:+ExplicitGCInvokesConcurrent -XX:MaxGCPauseMillis=10 -XX:GCPauseIntervalMillis=50 -XX:+UseFastAccessorMethods -XX:+OptimizeStringConcat -XX:NewSize=84m -XX:+UseAdaptiveGCBoundary -XX:NewRatio=3 -Dfml.readTimeout=90 -Dfml.queryResult=confirm"

# Set this to the root of the server files folder
SERVER_ROOT=$ROOT/instance/FeedTheBeast/serverfiles

########## Folder setup and permissioning ##########

# Ensure permissions are correctly set for all the folders
for x in instance config mods world backups; do
  # Make sure the directory exists and set permissions
  mkdir -p $ROOT/$x
  chown -R $POD_UID:$POD_GID $ROOT/$x
  restorecon -R $ROOT/$x
done

# Generate exclusion files for the logs folders
touch $ROOT/backups/.nobackup
mkdir -p $SERVER_ROOT/logs
touch $SERVER_ROOT/logs/.nobackup

# This instance uses server.cfg overrides for MAX_RAM and JAVA_ARGS.  Frustrating....
if [ -e $SERVER_ROOT/settings.cfg ]; then
        sed -i -e "s/^MAX_RAM=.*/MAX_RAM=$MAX_RAM/" $SERVER_ROOT/settings.cfg
        sed -i -e "s/^JAVA_ARGS=.*/JAVA_ARGS=$JAVA_ARGS/" $SERVER_ROOT/settings.cfg

fi

########## Pod startup script ##########

# Run up the container
#
# * JVM_XX_OPTS is ignored in this pack, JAVA_ARGS instead
# * We set all of those heaps of memory options to ensure that this should
#   work with all packs
podman run -it --name atm3r --dns 192.168.0.1 --dns 192.168.0.2 \
  --volume $ROOT/instance:/data:rw,slave,Z \
  --volume $ROOT/config:/config:rw,slave,Z \
  --volume $ROOT/mods:/mods:rw,slave,Z \
  --volume $ROOT/backups:/data/FeedTheBeast/serverfiles/backups:rw,slave,Z \
  --volume $ROOT/world:/data/FeedTheBeast/serverfiles/world:rw,slave,Z \
  --publish $PUBLISH \
  --cpus=4 \
  --cpu-shares=2048 \
  --memory=10g \
  --memory-reservation=2g \
  --restart=on-failure:3 \
  -e UID=$POD_UID \
  -e GID=$POD_GID \
  -e INIT_MEMORY=$MIN_RAM \
  -e MIN_RAM=$MIN_RAM \
  -e MAX_MEMORY=$MAX_RAM \
  -e MAX_RAM=$MAX_RAM \
  -e JAVA_ARGS="$JAVA_ARGS" \
  -e VERSION=1.12.2 \
  -e TYPE=CURSEFORGE \
  -e CF_SERVER_MOD='ATM3R-1.5.2_Server-FULL.zip' \
  -e FORCE_REDOWNLOAD=false \
  -e SERVER_PORT=$PORT \
  -e EULA=TRUE \
  -e OVERRIDE_SERVER_PROPERTIES=true \
  -e SERVER_NAME='ATM3R Home' \
  -e TZ='Australia/Adelaide' \
  -e MOTD='AllTheMods3 Remixed Server' \
  -e OPS='Mojang' \
  -e DIFFICULTY=normal \
  -e MODE=survival \
  -e FORCE_GAMEMODE=true \
  -e PVP=false \
  -e HARDCORE=false \
  -e MAX_TICK_TIME=-1 \
  -e VIEW_DISTANCE=8 \
  -e SNOOPER_ENABLED=false \
  -e ALLOW_FLIGHT=TRUE \
  -e ANNOUNCE_PLAYER_ACHIEVEMENTS=true \
  -e ENABLE_COMMAND_BLOCK=true \
  -e ALLOW_NETHER=true \
  -e GENERATE_STRUCTURES=true \
  -e MAX_BUILD_HEIGHT=256 \
  -e SPAWN_ANIMALS=true \
  -e SPAWN_MONSTERS=true \
  -e SPAWN_NPCS=true \
  -e LEVEL=world \
  itzg/minecraft-server:latest

########## End of script ##########
```

Now, once that's done, you will have an instance setup which looks like this;

```
+--- /srv/atm3r
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

1. Create an `instance` folder inside `/srv/atm3r` in this case.  Drop the downloaded server package ZIP for the modpack you're using in there.
2. Configure any parameters in the run script.
3. Run up the instance.  Once it's up, exit it.
4. Make any changes you needed to, like copying in config/mods etc.  You should have your initial world waiting for you in `world`.

## Updating an instance that already exists

Updating is also fairly straightforward;

1. Stop the instance and remove the container.
2. Move the instance folder elsewhere
3. Create a new instance folder and put the downloaded server package ZIP into it.
4. Edit your `run.sh` and put in the new name of the modpack (if any).
5. Start the instance.

Good luck!