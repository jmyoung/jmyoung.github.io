---
id: 765
title: Automating OpenVPN Push Routes
date: 2014-07-08T21:09:34+09:30
author: James Young
layout: post
guid: http://blog.zencoffee.org/?p=765
permalink: /2014/07/automating-openvpn-push-routes/
categories:
  - Technical
tags:
  - openwrt
---
Using [OpenVPN](https://openvpn.net/) with [OpenWRT](https://openwrt.org/) is a common solution for pushing routes out various egress points from your network.  However, maintaining a list of routes in your OpenVPN config is a nuisance, plus if the mapping from DNS name to IP address changes, they spontaneously break.  Additionally, you ideally want to use the DNS resolution of a name from the remote end of your VPN tunnel, not from the local end.

Enter the script I've put in my [GoogleCode Repository](https://github.com/jmyoung/zencoding-blog/tree/master/scripting/pushroutes). This script, when provided a config file like the following;

<pre># Example config file. Don't really use this.

config router myrouter.local

# vpn definitions
config addvpn myfirstvpn dns 10.0.1.1
config addvpn mysecondvpn dns 10.0.2.1
config defaultvpn myfirstvpn # inline comment

# a dns example route
route dns www.whatismyip.com dnsfailok target mysecondvpn

# an ip example route
route 8.8.8.8

# a network example route
route 10.1.1.0 netmask 255.255.255.0

</pre>

When run, the script will automatically configure routes in the appropriate sections of your OpenVPN config, insert hosts files entries pinning the DNS names to the remote-end resolutions of those names, and even upload the files and reload the relevant services on your OpenWRT router.  Magic!

You can't just use this as it is though, you need to prepare some files on your OpenWRT box, and you need to have ssh enabled with certificate auth for the machine you're running the pushroutes script from.  Read the top of the script to understand what it requires, and make sure you back up the relevant files from your OpenWRT router before running it.

The usual disclaimers apply to this kind of thing.  No warranties express or implied, author takes no responsibility for any damages, use at your own risk etc.

Good luck, I'm sure you can think of some great uses for this kind of automation.