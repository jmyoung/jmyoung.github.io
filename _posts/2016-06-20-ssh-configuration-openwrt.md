---
id: 913
title: SSH Configuration on OpenWRT
date: 2016-06-20T10:55:58+09:30
author: James Young
layout: post
guid: https://blog.zencoffee.org/?p=913
permalink: /2016/06/ssh-configuration-openwrt/
categories:
  - Technical
tags:
  - openwrt
format: aside
---
If you've configured [Dropbear](https://wiki.openwrt.org/doc/uci/dropbear) (the SSH server) for [OpenWRT](https://openwrt.org/) so that it has a secondary listener for your WAN port (you may want to do this if you want the WAN SSH listener on a different port from the default), then you've probably noticed that it doesn't come up on its own after your WAN link drops.

There's a really easy solution to this.  Configure hotplug.d so that when your WAN interface bounces, dropbear gets restarted!  Put this into /etc/hotplug.d/iface/40-dropbear ;

<pre>#!/bin/sh

if [ "$INTERFACE" = "wan" ] && [ "$ACTION" = "ifup" ]
then
 /etc/init.d/dropbear restart
fi</pre>

This tip was found at the bottom of the documentation for Dropbear listed above.