---
id: 849
title: Running daemons under Supervisord
date: 2016-02-02T15:07:05+09:30
author: James Young
layout: post
guid: http://blog.zencoffee.org/?p=849
permalink: /2016/02/running-daemons-supervisord/
categories:
  - Computers
  - Technical
tags:
  - docker
  - linux
---
<p style="text-align: left;">
  When you want to run multiple processes in a single Docker container, there's a few ways to do this.  Launch scripts is one.  I chose to use <a href="http://supervisord.org/">Supervisord</a>.  Supervisord has some cool features, but it's intended to manage processes that don't fork (daemonize) themselves.  If you have something that you want to run under Supervisord that you cannot stop from forking, you can use the following script to monitor it;
</p>

<pre>#! /usr/bin/env bash

set -eu

pidfile="/var/run/your-daemon.pid"
command="/usr/sbin/your-daemon"

# Proxy signals
function kill_app(){
 kill $(cat $pidfile)
 exit 0 # exit okay
}
trap "kill_app" SIGINT SIGTERM

# Launch daemon
$command
sleep 2

# Loop while the pidfile and the process exist
while [ -f $pidfile ] && kill -0 $(cat $pidfile) ; do
 sleep 0.5
done
exit 1000 # exit unexpected</pre>

Run that script with supervisord.  What will happen is the script will monitor your daemon until it exits for some reason, then the script will exit, resulting in supervisord taking action.

Solution found at [Serverfault](http://serverfault.com/a/608073).