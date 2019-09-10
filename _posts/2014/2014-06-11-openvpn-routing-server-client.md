---
id: 756
title: OpenVPN Routing from Server to Client
date: 2014-06-11T12:53:04+09:30
author: James Young
layout: post
guid: http://blog.zencoffee.org/?p=756
permalink: /2014/06/openvpn-routing-server-client/
categories:
  - Computers
  - Other
  - Technical
tags:
  - openwrt
  - vps
---
There's a lot of guides about how to use OpenVPN to push arbitrary routes (usually to defeat geolocking) from an OpenVPN client to a server.  However, my requirements are actually backwards.  I need to be able to push routes from my server to a client (since the 'server' is my home router).  This requires a different rule set from normal.

# Masquerading

Firstly, the machine that has is going to function as the egress point to the Internet has to be configured to allow IPv4 forwarding and also to allow masquerading (so that packets intended to be forwarded from the internal network to the Internet can be re-tagged with the egress point external IP address).

In /etc/sysctl.conf, set net.ipv4.ip_forward to 1.  Then, you'll need the following iptables rules (eth0 is the egress interface, tun0 is the internal interface);

<pre>echo 1 &gt; /proc/sys/net/ipv4/ip_forward
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
iptables -A FORWARD -i eth0 -o tun0 -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -i tun0 -o eth0 -j ACCEPT
iptables -A FORWARD -j LOG
iptables -A FORWARD -j DROP</pre>

The first rule causes traffic outbound on the egress interface to be masqueraded (NAT).  The second rule causes inbound traffic going from the egress interface to the internal interface to be accepted if it's part of an established or related connection (ie, packets coming back).  The third rule causes packets destined to be forwarded from the internal interface to the egress interface to be accepted.  And the last two rules log anything else and drop them.

# OpenVPN Server Configuration

Now, the OpenVPN server needs to be told what routes should be directed into the tun adapter.  As an example, we'll use whatismyip.com .  In /etc/config/openvpn, add the following;

<pre>list route '141.101.120.14 255.255.255.255'
list route '141.101.120.15 255.255.255.255'</pre>

When OpenVPN is restarted, it will automatically put the correct entries in your router's routing table to direct traffic to those IPs out your tun adapter.  However, that's not all.

# OpenVPN Client Configuration (on server)

If OpenVPN receives traffic on the tun adapter for those IPs, it doesn't know which connected client should receive the packets and so it drops them.  You will also need iroutes for those networks in the client configuration directives for your client;

<pre>iroute 141.101.120.14 255.255.255.255
iroute 141.101.120.15 255.255.255.255</pre>

Right, that's it.  Restart OpenVPN and connect to it.

# Testing

Try and ping one of the routes you've added.  If it works, great!  If not, the first thing to check is that the traffic is actually getting routed.  Examine the router's routing table with 'route' and see if the route is listed.

Assuming it is, on your client end, run the following;

<pre>tcpdump -i tun0</pre>

When trying to ping, you should see packets land.  If you do, this tells you that packets are hitting your router, being redirected into OpenVPN, OpenVPN is passing them down the tunnel and they're breaking out at the tun interface on your client.  Check your firewall log on the client and make sure your firewall rules are fine.

If you don't see the packets landing on the tun interface, check logread on your router.  If there are complaints about packets being dropped, examine /tmp/openvpn.status and make sure that the route is listed in the OpenVPN routing table.

Anyway, good luck.  I'm sure you can come up with some creative ways of having your routing come out a different egress point than usual 🙂