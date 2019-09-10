---
id: 21
title: IPSec/L2TP VPN Server on CentOS 6 (PSK)
date: 2012-10-24T05:44:00+09:30
author: James Young
layout: post
guid: http://wordpress/wordpress/?p=21
permalink: /2012/10/ipsecl2tp-vpn-server-on-centos-6-psk/
blogger_blog:
  - coding.zencoffee.org
blogger_author:
  - James Young
blogger_permalink:
  - /2012/10/ipsecl2tp-vpn-server-on-centos-6-psk.html
categories:
  - Technical
tags:
  - linux
  - security
---
I've been using PopTop (a PPTP implementation) for quite some time now, but it appears that the PopTop Sourceforge site recently died and hasn't come back.  In addition, PopTop hasn't been updated in nearly five years.  Probably time to move on.

After a LOT of fighting (trying all sorts of things, including Racoon, OpenVPN, and finally OpenSWAN), I've got a working solution that runs fine with CentOS 6.3, and doesn't require any funny repos or anything.

OpenSWAN + xl2tpd + PPP.  My understanding of how this stuff bolts together is a bit limited, but here goes...

## Network Setup

I'm assuming the following network setup;

  * A client machine, off your network on the Internet somewhere.  You want that client to be able to get into your local network remotely and do 'stuff'.
  * Your CentOS server has a single NIC, is running a DNS server locally, and has the IP address 192.168.1.20 .
  * You have a NATting firewall (a router) on your network at 192.168.1.254 which provides access to the Internet.
  * You have already configured port forwarding on your router to forward UDP ports 500, 4500 and 1701 to your CentOS server.
  * You want your VPN clients to appear in the IP range 192.168.1.2 - 192.168.1.10, and this range is NOT in your dhcp scope.
  * You want to use a pre-shared key to get IPSEC working (certificates later!)

Reiterating;

  * 192.168.1.0/24 - Internal LAN
  * 192.168.1.1 - Peer local IP to be used by VPN server for L2TP tunnels
  * 192.168.1.2 through 10 - Local IP range to be used for L2TP tunnels, not in DHCP scope
  * 192.168.1.20 - Private LAN interface of VPN server.
  * 192.168.1.20 - DNS server to be used by VPN clients
  * 192.168.1.254 - NATting border router

## The Sequence

**OpenSWAN** provides the IPSEC component, encapsulating packets from the client to/from the server, providing basic network connectivity and authentication.  On connection, the client provides a pre-shared key to the server, and then OpenSWAN establishes the IPSEC tunnel and passes control to xl2tpd.

**xl2tpd** provides the component which connects the two disparate networks (the client's and the server's) together.  It talks to pppd to authenticate a user, and then makes that user appear on the local network as some IP in its defined range.

**pppd** provides authentication for users.  This way, there are TWO passwords required - one for the ipsec component provided by OpenSWAN, and one for the actual user account who is connecting to the VPN.

## Setting it up

First, install the appropriate packages.

<pre>yum install openswan xl2tpd pppd
chkconfig ipsec on
chkconfig xl2tpd on</pre>

Then, edit /etc/sysctl.conf and set net.ipv4.ip_forward to 1.  Then, edit /etc/rc.local and add the following at the bottom;

<pre><span style="color: #666666; font-family: Consolas;"># Correct ICMP Redirect issues with OpenSWAN
for each in /proc/sys/net/ipv4/conf/*; do
        echo 0 &gt; $each/accept_redirects
        echo 0 &gt; $each/send_redirects
        echo 0 &gt; $each/rp_filter
done</span></pre>

This corrects some issues with OpenSWAN and ICMP redirect packets.  Now, edit /etc/ipsec.conf and make it look like the following;

<pre>config setup
        klipsdebug=none
        plutodebug=none
        protostack=netkey
        nat_traversal=yes
        virtual_private=%v4:192.168.1.0/24
        interfaces="%defaultroute"
        oe=off

conn L2TP-PSK
        authby=secret
        pfs=no
        auto=add
        keyingtries=3
        rekey=no
        type=transport
        forceencaps=yes
        right=%any
        rightsubnet=vhost:%no,%priv
        rightprotoport=17/%any
        leftnexthop=%defaultroute
        left=%defaultroute
        leftprotoport=17/1701</pre>

What's happening here is that we define a new IPSEC connection where the right (the local side) is on the private network, and the left (the remote side, the client) is coming from the router and on port 1701.

Next up, we edit /etc/ipsec.secrets and define a PSK secret for this connection;

<pre>192.168.1.20   %any:   PSK yourpasswordhere</pre>

That does it for OpenSWAN.  Next we configure xl2tpd by editing /etc/xl2tpd/xl2tpd.conf and making it look like this;

<pre>[global]
listen-addr = 192.168.1.20

[lns default]
ip range = 192.168.1.2-192.168.1.9
local ip = 192.168.1.1
refuse pap = yes
require authentication = yes
name = YourServerNameHere
ppp debug = no
pppoptfile = /etc/ppp/options.xl2tpd
length bit = yes</pre>

There's a few notable points here.  Firstly, the listen address is the local network address of the server.  Secondly, the ip range should be on the local network but not in your DHCP scope.  The local ip used should not be the same as the listen address AND should not be in the ip range.  Then we edit /etc/ppp/options.xl2tpd ;

<pre>ipcp-accept-local
ipcp-accept-remote
ms-dns 192.168.1.20
noccp
auth
crtscts
idle 1800
mtu 1410
mru 1410
nodefaultroute
debug
lock
proxyarp
connect-delay 5000</pre>

You should set ms-dns to the DNS server you want your VPN clients to use.  And lastly, we edit /etc/ppp/chap-secrets and insert records for the accounts we want to be able to use VPN;

<pre># Secrets for authentication using CHAP
# client        server  secret                  IP addresses
youruserhere    *       yourpasswordhere        *</pre>

With this done, you're done with the xl2tpd component.  I'd advise you turn on the logging when you go to start all the services.  Start them up, and you should be able to connect!

Next up, requiring certificates.