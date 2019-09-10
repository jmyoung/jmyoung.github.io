---
id: 971
title: Customizing OwnCloud using Docker
date: 2016-09-23T14:19:09+09:30
author: James Young
layout: post
guid: https://blog.zencoffee.org/?p=971
permalink: /2016/09/customizing-owncloud-using-docker/
categories:
  - Technical
tags:
  - docker
---
I'm messing around with [OwnCloud](https://owncloud.org/) at the moment, a solution to provide cloud-like access to files and folders through a webapp using your own local storage.  As is my want, I'm doing it in Docker.

There's a minor catch though - the official [OwnCloud Docker image](https://hub.docker.com/_/owncloud/) does not include `smbclient`, which is required to provide access to Samba shares.

Here's how to take care of that.

<pre>FROM owncloud:latest
RUN set -x; \
 apt-get update \
 && apt-get install -y smbclient \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /var/cache/apt/archives/*</pre>

The above Dockerfile will use the current `owncloud:latest` image from Docker Hub, and then install `smbclient` into it.  You want to do the update, install and cleanup in one step so it gets saved as only one layer in the Docker filesystem, saving space.

You can then put that together with the official [MySQL Docker Image](https://hub.docker.com/_/mysql/) and a few volumes to have a fully working OwnCloud setup with `docker-compose`.

<pre>version: '2'

services:
  mysql:
    image: mysql:latest
    restart: unless-stopped
    environment:
      - MYSQL_ROOT_PASSWORD=passwordgoeshere
    volumes:
      - ./data/mysql:/var/lib/mysql:rw,Z

  owncloud:
    hostname: owncloud.localdomain
    build: owncloud/
    restart: unless-stopped
    environment:
      - MYSQL_ROOT_PASSWORD=passwordgoeshere
    ports:
      - 8300:80
    volumes:
      - ./data/data:/var/www/html/data:rw,Z
      - ./data/config:/var/www/html/config:rw,Z
      - ./data/apps:/var/www/html/apps:rw,Z
    depends_on:
      - mysql
</pre>

Create the directories that are mounted there, set the password to something sensible, and `docker-compose up` !

One thing though.  OwnCloud doesn't have any built-in account lockout policy, so I wouldn't go putting this as it is on the 'Net just yet.  You'll want something in front of it for security, like nginx.  You'll also want HTTPS if you're doing that.

More on that later.