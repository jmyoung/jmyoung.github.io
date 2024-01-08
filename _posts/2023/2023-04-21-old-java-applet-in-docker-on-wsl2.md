---
title: 'Old Java Applets in Docker on WSL2'
author: James Young
layout: post
categories:
  - technical
tags:
  - wsl
  - docker
---

A quick snippet.  Sometimes it is necessary to have a very old browser kicking around somewhere with all the security hooks turned off and with an old version of Java on it.  The usual use case for this is getting access to some kind of embedded console, and you certainly do not want to be using that as your standard browser.  A throwaway container that can run the browser for you on demand is exactly what is needed in that situation.

When using WSL2 on Windows 11, Windows has a built-in X server that you can use.  This should Just Work(tm).  When you have Docker Desktop installed in Windows, you can also get access to the Docker Engine through WSL2.  Combining the two, with an excellent Java Applet Player from DockerHub, we can do the following to bring up a web browser in an isolated container and show it on our Windows desktop for use;

```bash
docker run -d --name java-player --publish 2222:22 desktopcontainers/java-applet-player
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -X app@localhost -p 2222
```

That command brings up a Docker container running the Java Applet Player, and then runs up SSH in X forwarding mode to connect to it.  When you're done and you close the browser window, you can then discard the container with;

```bash
docker kill java-player
docker rm java-player
```

You can also just leave the player stopped, and start it again when you next want to use it, if you want any persistence between sessions.
