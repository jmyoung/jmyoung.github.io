---
id: 841
title: Simple NAT Traversal with Asterisk
date: 2015-12-23T22:01:22+09:30
author: James Young
layout: post
guid: http://blog.zencoffee.org/?p=841
permalink: /2015/12/simple-nat-traversal-asterisk/
categories:
  - Technical
  - Telephony
tags:
  - asterisk
  - voip
---
As an experiment, I configured Asterisk for full NAT traversal so that my SIP server could be accessed from the Internet.  This isn't usually what you want, but here's how you do it...

_**DANGER** - Doing this will expose your Asterisk SIP server directly to the Internet, and you'll get all manner of violated by SIP spammers.  Be aware of what you're doing and what the implications are._

I'm assuming that you have a typical home NAT setup, where you have a dynamic IP, you're in control of the border firewall (so you can do port forwarding), and your Asterisk install is on an internal network.

## Step 1- Port Forwarding

First up, on your firewall, port forward the following ports to your Asterisk box;

<pre>5060/udp         # SIP control channel
10000:11000/udp  # the ports we will use for RTP</pre>

## Step 2 - RTP Port Ranges

Right.  Now, create an rtp.conf in your Asterisk config, containing the following;

<pre>[general]
rtpstart=10000
rtpend=11000</pre>

This constrains the list of allowed RTP ports for SIP to use for communications.

## Step 3 - Lockdown

Now, a word on security.  Put the following into the [general] section of your sip.conf;

<pre>context=incoming-public
allowguest=no
alwaysauthreject=yes</pre>

Now in your extensions.conf, define that context **and put nothing in it**.  Anyone who dials in anonymously to your SIP server will be directed to that context and go nowhere.  This is what you want (presumably).  For the love of God, do not put anything outbound in that context!

## Step 4 - Configure NAT Traversal

In your sip.conf, in the [general] section (it must be there), add the following;

<pre>externhost=PUT-YOUR-DYNAMIC-DNS-HOSTNAME-HERE
localnet=192.168.0.0/255.255.255.0</pre>

This causes the Contact headers of outbound SIP packets to be substituted with the IP address of the DNS name you specified there, if the destination is not in the localnet field.  This is important to make NAT traversal work.

## Step 5 - Configure SIP peers

For each of your peers, configure them to use NAT traversal as follows (some of these options may not be strictly required, but this is what I did and it worked);

<pre>nat=force_rport
qualify=yes
canreinvite=no
directmedia=no</pre>

## Step 6 - Wait for the bots

Now, if this has all worked, you should now be able to connect to your SIP server from the Internet.

May God have mercy on your server.