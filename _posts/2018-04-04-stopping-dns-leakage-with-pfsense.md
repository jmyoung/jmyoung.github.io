---
id: 1060
title: Stopping DNS leakage with pfSense
date: 2018-04-04T13:39:34+09:30
author: James Young
layout: post
guid: https://blog.zencoffee.org/?p=1060
permalink: /2018/04/stopping-dns-leakage-with-pfsense/
categories:
  - Computers
  - Technical
tags:
  - pfsense
  - security
---
I've recently changed my core router over from [OpenWRT](https://openwrt.org/) to [pfSense](https://www.pfsense.org/).  I was pretty happy with OpenWRT, but I wanted something more powerful since it was running in a VM anyway.

A few days ago, CloudFlare announced their new [1.1.1.1 service](https://1.1.1.1/).  This is a public DNS service very much like Google's [8.8.8.8 DNS](https://developers.google.com/speed/public-dns/docs/using) service, with a notable difference.  It supports TLS.

Why should you care?  Because DNS requests are normally not encrypted, and therefore visible to your ISP to record, use for research / marketing purposes, or even (in the case of some nefarious actors) manipulate or change.  Running DNS over TLS prevents that, by encrypting your DNS traffic so that it can't be manipulated or collected.

In this post, we'll be configuring pfSense to do three things - provide a local standard unencrypted port 53 DNS resolver which uses CloudFlare's 1.1.1.1 encrypted service on the WAN end, and then set up a NAT redirect so any attempts on the internal network to use port 53 DNS servers outside the network instead are intercepted and resolved by the internal resolver.  Lastly, it will also make sure that it blocks any outbound requests to port 53 just to be sure.

**NOTE:  There's one piece here I haven't figured out yet.  How to pin a cert for the DNS endpoints listed here, so it's not perfect.  When I figure that out, I'll edit this post.**

Let's get started.

## Configuring the pfSense Local Resolver

In pfSense, go to Services -> DNS Resolver, then put the following block into Custom Options:

<pre>server:
ssl-upstream: yes
do-tcp: yes
forward-zone:
    name: "." 
    forward-addr: 1.1.1.1@853
    forward-addr: 1.0.0.1@853
    forward-addr: 2606:4700:4700::1111@853
    forward-addr: 2606:4700:4700::1001@853</pre>

You will also need to make sure that the `DNS Query Forwarding` option is NOT selected, otherwise the above settings will conflict.  It's OK to set the resolver to listen on all interfaces, since the firewall rules on the WAN will prevent Internet hosts from using your resolver anyway.  Follow the prompts, then test it with something like;

<pre>dig www.google.com @yourrouter.local</pre>

You should see a resolve against your router's local DNS resolver that works.  If you really want, use Diagnostics -> Packet Capture, and capture port 853 to verify that requests are being triggered.

## Redirect all DNS requests to outside DNS servers to pfSense

Follow the article you can find here.  You will need to do this once for each of your interfaces (in my case, LAN, DMZ, and VPN).  Obviously don't configure this for the WAN interface.  This then causes any requests to addresses that are not on your internal network to be resolved through the local pfSense resolver (which goes out to port 853 anyway).

To test this, try and dig something against an IP that you know is not internal and is not a DNS server.  It should work, since the request will be NATted.  Something like;

<pre>dig www.google.com @1.2.3.4</pre>

Assuming that's all fine, you should now be able to configure a broad block rule to bar all outbound port 53.

## Block all outbound non-encrypted DNS

This shouldn't really be required if the NAT rule is working, but we'll do it anyway to be sure we're stopping any DNS leaks.

In pfSense, go to Firewall -> Rules, and for the WAN interface, define a new rule at the top of the list.  This rule should use these settings;

<pre>Action: Block
Interface: WAN
Address Family: IPv4+IPv6
Protocol: TCP/UDP
Source: any
Destination: any
Destination Port: DNS (53)
Description: Block outbound insecure DNS</pre>

After doing this, verify that you can still resolve against the local resolver (your router's IP), and that you can still resolve against what seems to be external resolvers (eg, 8.8.8.8).  You should also check that when you do so that nothing passes on the WAN interface on port 53.

If that all passes, you're done.   It's up to you if you use the 'Block' target or the 'Reject' target.  Block causes a simple timeout if something hits 53 (which shouldn't happen anyway), Reject causes an immediate fail.

## Resources

  * [Redirecting all DNS requests to pfSense](https://doc.pfsense.org/index.php/Redirecting_all_DNS_Requests_to_pfSense)
  * [Unbound Config for Cloudflare 1.1.1.1](https://www.reddit.com/r/PFSENSE/comments/897boi/dns_over_tls_for_1111/)