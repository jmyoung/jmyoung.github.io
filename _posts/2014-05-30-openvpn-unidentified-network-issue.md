---
id: 752
title: 'OpenVPN &#8211; Unidentified Network issue'
date: 2014-05-30T14:53:23+09:30
author: James Young
layout: post
guid: http://blog.zencoffee.org/?p=752
permalink: /2014/05/openvpn-unidentified-network-issue/
categories:
  - Technical
tags:
  - openwrt
---
Discovered a little wrinkle in Windows 7's Network Identification feature.  If you're pushing an OpenVPN tunnel to a machine and not substituting the default gateway (because, for example, you want a split tunnel) with the VPN's gateway, then Windows just consistently won't identify the network, which means you're stuck with the "Public" firewall profile.

Fortunately the solution's pretty easy.  In the client config directives for your client, you define a new default route with a very high metric pointing to the peer address for the client, eg;

<pre>ifconfig-push 10.0.2.101 10.0.2.102
push "route 0.0.0.0 0.0.0.0 10.0.2.102 500"</pre>

So now, when that client connects, it will have the IP address 10.0.2.101 and a peer address of 10.0.2.102 .  We define a new default route going to 10.0.2.102 with a very high metric.  This ensures that this route doesn't get used unless the real default route is broken.

Connect up, and voila!  Windows identifies the network, and you can give it a name and change its type from 'Public' to 'Home'.