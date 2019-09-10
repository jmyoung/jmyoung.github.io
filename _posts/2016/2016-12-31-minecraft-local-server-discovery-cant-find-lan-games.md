---
id: 990
title: 'Minecraft Local Server Discovery &#8211; Can&#8217;t find LAN games?'
date: 2016-12-31T19:14:18+09:30
author: James Young
layout: post
guid: https://blog.zencoffee.org/?p=990
permalink: /2016/12/minecraft-local-server-discovery-cant-find-lan-games/
categories:
  - Gaming
tags:
  - windows
---
I had a problem where I couldn't find LAN games automatically on my local network in Minecraft.  Turns out that the problem was due to the interface priority on my network interfaces, and Minecraft was binding to the wrong interface!

Minecraft uses UDP multicast (on 224.0.2.60, port 4445) to advertise local games.  If you have more than one network adapter on your machine (in my case, a VirtualBox Host-Only adapter), it's possible that Minecraft has bound to the wrong adapter.

You can reveal this with `netsh interface ip show joins` - if you see the join on 224.0.2.60 on the wrong interface, that's your problem.  Here's how to fix it.

Open an administrative Powershell prompt.  Run `get-netipinterface` and review.  You should see two entries for the offending adapter.  Look at the InterfaceMetric value for that adapter and for the adapter you want to be the default.  In my case, both were 25.

You can now adjust the interface metric for the offending adapter to be **higher** than the correct adapter;

<pre>get-netipinterface | where-object { $_.InterfaceAlias -like "VirtualBox*" } | set-netipinterface -interfacemetric 40</pre>

And voila!  Minecraft local server discovery works again!