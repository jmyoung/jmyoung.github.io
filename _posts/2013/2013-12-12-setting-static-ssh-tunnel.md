---
id: 704
title: Setting up a static SSH tunnel
date: 2013-12-12T09:06:16+09:30
author: James Young
layout: post
guid: http://blog.zencoffee.org/?p=704
permalink: /2013/12/setting-static-ssh-tunnel/
categories:
  - Computers
  - Technical
tags:
  - linux
  - vps
---
So, I have a Microserver sitting at home, and due to various reasons I wanted to move one of the services that I typically ran on the Microserver across to my VPS.  The reason why I wanted to do this is to save CPU cycles on the Microserver since I'm planning on using those to do some other work.  But the service I wanted to move is intended for local access only and I don't want to set up a proper site-to-site VPN.

Enter SSH.  I was given the idea by a colleague that I could run up an SSH tunnel on the Microserver to connect to my VPS and establish local (and remote!) redirects as required to do what I want, without opening any dangerous holes in the VPS firewall.

What I wanted to do was the following;

  * Allow machines on my local network to connect to localhost:80 on the VPS.
  * Allow a local service on the Microserver to connect to a fixed destination using the VPS as the source
  * Allow a local service on the VPS to connect to a local service on the Microserver

This can be done with a simple command line;

<pre>ssh -L *:880:localhost:80 -L 4443:www.google.com:443 -R 880:localhost:80 username@yourvpsdomain</pre>

The components are;

  * **-L *:880:localhost:80** - Establish a local (ie, from Microserver to VPS) port redirect from port 880 on the Microserver, going to the VPS's localhost (ie, itself) at port 80.  The port 880 listener will listen on all interfaces on the Microserver, so anything on the Microserver's local network can access that.
  * **-L 4443:www.google.com:443** - Establish a local port redirect from port 4443 on the Microserver going to www.google.com port 443.  This only listens on the Microserver's loopback interface so is only available on the Microserver.  Anything that connects to this is connected to www.google.com:443 through the VPS, so the source address will be the VPS.
  * **-R 880:localhost:80** - Establish a remote port redirect from port 880 on the VPS going to the Microserver's loopback interface at port 80.  This only listens on the VPS's loopback interface.  This means that anything on the VPS can connect to port 880 and be connected to the Microserver's port 80.

Right, now we've done that and it works, we need to script it so it'll stay up on its own.  First, we establish SSH keys so that we can connect without a password.  I'll assume you put that in **/root/.ssh/id_rsa** (the default location).

Now, we write a new cron script in **/etc/cron.hourly**;

<pre>#!/bin/bash
<span style="font-size: 0.857142857rem; line-height: 1.714285714;">
RUNNING=`ps aux | grep "ssh -i /root/.ssh/id_rsa -L .:880:localhost:80 " | grep -v grep | wc -l`

</span>if [ $RUNNING -eq 0 ]; then
    screen -dm ssh -i /root/.ssh/id_rsa -L *:880:localhost:80 -L 4443:www.google.com:443 -R 880:localhost:80 username@yourvpsdomain
fi</pre>

<span style="line-height: 1.714285714; font-size: 1rem;">Operation is simple.  Once an hour it will check to see if the tunnel is already running, and if it's not will spin one up via screen.  Done.</span>