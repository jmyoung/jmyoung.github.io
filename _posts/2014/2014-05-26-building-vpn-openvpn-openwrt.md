---
id: 748
title: Building a VPN with OpenVPN and OpenWRT
date: 2014-05-26T15:25:15+09:30
author: James Young
layout: post
guid: http://blog.zencoffee.org/?p=748
permalink: /2014/05/building-vpn-openvpn-openwrt/
categories:
  - Computers
  - Technical
tags:
  - openwrt
  - security
  - vps
---
I wound out replacing my existing router (which had a buggy NAT issue) with a [TP-Link TL-WR1043ND](http://www.tp-link.com/en/products/details/?model=TL-WR1043ND) running [OpenWRT](https://openwrt.org/).  It was pretty damned easy to get it all running and set it up as an in-place upgrade.  However, I wanted more out of it.

What I want to do is to establish a VPN tunnel such that my VPS has some (highly restricted) access to my local network, and my local network has (nearly) unrestricted access to the VPS.  I also want to have other devices (my phone) able to connect to my local network using VPN and have unrestricted access.  And lastly, I want to do this with certificates (and not shared secrets).  To do this, I used [OpenVPN](http://openvpn.net/).

# Desired Topology

  * 10.0.0.0/24 - Internal LAN
  * 10.0.2.0/24 - Trusted VPN
  * 10.0.3.0/24 - Untrusted (DMZ) VPN

# OpenWRT Configuration

## Package Installation and TUN Configuration

First, run the following to install the required packages;

<pre>opkg update
opkg install openvpn-openssl
opkg install openvpn-easy-rsa</pre>

Once that's done, edit /etc/config/network and add a declaration of a new TUN interface;

<pre>config interface 'vpn'
    option proto 'none'
    option ifname 'tun0'</pre>

Reboot your router, and you'll find a new interface tun0 waiting.  Now you need to set up your PKI infrastructure and generate some certs.

## Configure PKI

Follow the [installation instructions](http://openvpn.net/index.php/open-source/documentation/miscellaneous/77-rsa-key-management.html) for easy-rsa.  Once that's done, you will have a functional self-signed CA.  Go and generate some certificates like this;

<pre>build-key-server server
build-key trustedclient
build-key dmzclient</pre>

Take server.crt and server.key and copy them into the OpenVPN configuration;

<pre>cp /etc/easy-rsa/server.* /etc/openvpn/
mkdir /etc/openvpn/clients/</pre>

You've now got a basic PKI setup, and two client certificates ready to go, along with the server certificate for OpenVPN.

## Configure OpenVPN Server

Edit /etc/config/openvpn like this;

<pre>package openvpn

config openvpn trusted_vpn
        option enabled          1
        option port             1194
        option proto            udp
        option dev              tun
        option ca               /etc/easy-rsa/keys/ca.crt
        option cert             /etc/openvpn/server.crt
        option key              /etc/openvpn/server.key
        option dh               /etc/easy-rsa/keys/dh2048.pem
        option keepalive        '10 120'
        option comp_lzo         yes
        option persist_key      1
        option persist_tun      1
        option verb             3
        option status           /tmp/openvpn.status
        option log              /tmp/openvpn.log
        option ccd_exclusive    1
        option client_config_dir        /etc/openvpn/clients
        option server           '10.0.2.0 255.255.255.0'
        option route            '10.0.3.0 255.255.255.0'
        list push               "route 10.0.0.0 255.255.255.0"
        list push               "dhcp-option DOMAIN localdomain.local"
        list push               "dhcp-option DNS 10.0.0.254"</pre>

You should disable the log once you've got everything working.  What this does is the following;

  * Clients must have a matching client config entry in /etc/openvpn/clients to be able to connect
  * The server by default uses 10.0.2.0/24 for connecting clients, but also has a route for 10.0.3.0/24 down the TUN interface
  * The server pushes a route to the client for 10.0.0.0/24, along with a couple of settings that are used by Windows clients (setting local domain and DNS servers to use)

For your trusted client, create a file /etc/openvpn/clients/trustedclient which has this line in it;

<pre>ifconfig-push 10.0.2.101 10.0.2.102</pre>

This causes the trusted client to always get the IP address 10.0.2.101.  Note, as per the [OpenVPN documentation,](https://openvpn.net/index.php/open-source/documentation/howto.html) in order for the ifconfig-push'ed addresses to work with WIndows clients properly, they must come from the set;

<pre>[  1,  2] [  5,  6] [  9, 10] [ 13, 14] [ 17, 18]
[ 21, 22] [ 25, 26] [ 29, 30] [ 33, 34] [ 37, 38]
[ 41, 42] [ 45, 46] [ 49, 50] [ 53, 54] [ 57, 58]
[ 61, 62] [ 65, 66] [ 69, 70] [ 73, 74] [ 77, 78]
[ 81, 82] [ 85, 86] [ 89, 90] [ 93, 94] [ 97, 98]
[101,102] [105,106] [109,110] [113,114] [117,118]
[121,122] [125,126] [129,130] [133,134] [137,138]
[141,142] [145,146] [149,150] [153,154] [157,158]
[161,162] [165,166] [169,170] [173,174] [177,178]
[181,182] [185,186] [189,190] [193,194] [197,198]
[201,202] [205,206] [209,210] [213,214] [217,218]
[221,222] [225,226] [229,230] [233,234] [237,238]
[241,242] [245,246] [249,250] [253,254]</pre>

Next, we repeat this with the DMZ client, but with a small change - we'll also push the route for the trusted network.  This is required because otherwise the router itself cannot contact anything in the DMZ due to the router's interface IP being in the 10.0.2.0/24 range.

Create /etc/openvpn/clients/dmzclient as follows;

<pre>ifconfig-push 10.0.3.101 10.0.3.102
push route "10.0.2.0 255.255.255.0"</pre>

That concludes the OpenVPN server config.  Now for the firewall.

## Firewall Configuration

### OpenVPN Access Port

Edit /etc/config/firewall .  Up fairly high, amongst any other port forwards, add the following;

<pre>config rule
    option name 'OpenVPN-Access'
    option src wan
    option proto udp
    option dest_port 1194
    option family ipv4
    option target ACCEPT</pre>

This allows your VPN to be accessible from the 'net.

### Full-Access VPN Zone

Next, we'll create a new zone for the full-access VPN, but we'll specify that it only applies to a specific subnet;

<pre>config zone
        option name             vpn
        option input            ACCEPT
        option forward          REJECT
        option output           ACCEPT
        list network            vpn
        list subnet             '10.0.2.0/24'
        option masq             0
        option mtu_fix          1

config forwarding
        option dest             lan
        option src              vpn

config forwarding
        option dest             vpn
        option src              lan</pre>

### DMZ VPN Zone

And lastly we'll define a new zone for the DMZ VPN along with allowed traffic.  Note that this does not specify a subnet, that way any traffic that comes in on the tun network that does not match the trusted VPN falls through to the DMZ zone.

<pre>config zone
        option name             dmz
        option input            REJECT
        option forward          REJECT
        option output           ACCEPT
        list network            vpn
        option masq             0
        option mtu_fix          1

config rule
        option name             'http-Linkage'
        option src              dmz
        option dest             lan
        option proto            tcp
        option src_ip           10.0.3.101
        option dest_port        80
        option dest_ip          10.0.0.15
        option family           ipv4
        option target           ACCEPT

config rule
        option name             Allow-DMZ-Ping
        option src              dmz
        option dest             lan
        option proto            icmp
        option icmp_type        echo-request
        option family           ipv4
        option target           ACCEPT

config forwarding
        option dest             dmz
        option src              lan</pre>

Notably, there is only a forward here from lan to dmz, that way we have to specifically allow what traffic we want to be passed from dmz to lan.  Here, I allow the DMZ machine to ping into my local network, and to connect to 10.0.0.15 on port tcp/80 only.

## OpenVPN Server Summary

Essentially, what we've done is create two network zones which are pushed out by OpenVPN.  The firewall controls access between them.  Which user certificate lands in which zone is determined by the IP they're assigned by OpenVPN on connect, which is defined by the configuration file in /etc/openvpn/clients.  All clients must have a config file waiting for them in this setup.

IMPORTANT - Don't forget to add /etc/openvpn and /etc/easy-rsa to your /etc/sysupgrade.conf, otherwise you'll lose all this on upgrading your router.  That would be unfortunate.

# OpenVPN Client Setup (DMZ Client)

You will require the following components to configure your client;

  * /etc/easy-rsa/keys/ca.crt
  * /etc/easy-rsa/keys/dmzclient.crt
  * /etc/easy-rsa/keys/dmzclient.key

Download those off your router and store them somewhere.  Then, you'll need to create a client.ovpn file in the same folder as follows;

<pre>client
dev tun
remote yourvpnserverhostname 1194
resolv-retry infinite
nobind
persist-key
persist-tun
ns-cert-type server
ca /etc/openvpn/ca.crt
cert /etc/openvpn/dmzclient.crt
key /etc/openvpn/dmzclient.key
comp-lzo
route-nopull
route 10.0.0.0 255.255.255.0
route 10.0.2.0 255.255.255.0</pre>

In my case, the files are in /etc/openvpn, as the config shows.  Notably, this config also does not pull route data from the OpenVPN server but instead sets it by itself.  Then, start your VPN with

<pre>openvpn --config client.ovpn</pre>

And it should all work!  If not, consult the logs, and good luck!