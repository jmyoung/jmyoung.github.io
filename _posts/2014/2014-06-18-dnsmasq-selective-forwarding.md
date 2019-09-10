---
id: 759
title: DNSMasq Selective Forwarding
date: 2014-06-18T15:46:28+09:30
author: James Young
layout: post
guid: http://blog.zencoffee.org/?p=759
permalink: /2014/06/dnsmasq-selective-forwarding/
categories:
  - Technical
tags:
  - linux
  - openwrt
  - vps
---
Now, if you're using an OpenVPN selective routing tunnel like I've been discussing to push specific subnets through a tunnel, then you probably also have good reason to want to force specific DNS domains to resolve through a DNS server that is also on the the other end of that tunnel (eg, an internal network).

If your DNS server is on your OpenWRT router and is running dnsmasq, this is really easy.  First on the remote end of the tunnel you'll need a DNS forwarder set up;

<pre>yum install dnsmasq
chkconfig dnsmasq on
service start dnsmasq</pre>

Make sure that's suitably firewalled off so it's only accessible from the tun interface, otherwise you'll find yourself being used for DNS-based DDOS.

Next, you'll need to edit your dnsmasq config in /etc/dnsmasq.conf and add the following (this example redirects anything in the google.com domain to resolve on the other end of the tunnel);

<pre>server=/google.com/10.0.1.1</pre>

I'm assuming that the peer address of the remote end of the tunnel is 10.0.1.1 .  It will be the .1 in whatever subnet that VPN server is pushing.  Restart dnsmasq after doing this.

Now, anything that is inside google.com (eg, ssl.google.com, www.google.com and just plain google.com) will be resolved using the DNS server that's responding at 10.0.1.1, which is the remote end of your tunnel.

The reason why you want a forwarder set up on the remote end of the tunnel is so that you have a unique per-tunnel address to use in the dnsmasq config.  If you already have unique per-tunnel DNS addresses to use, nothing's stopping you just using those and skipping the installation of dnsmasq on the remote end.