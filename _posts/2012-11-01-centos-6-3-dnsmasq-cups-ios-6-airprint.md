---
id: 20
title: CentOS 6.3 + DNSMASQ + CUPS + iOS 6 + AirPrint
date: 2012-11-01T00:24:00+09:30
author: James Young
layout: post
guid: http://wordpress/wordpress/?p=20
permalink: /2012/11/centos-6-3-dnsmasq-cups-ios-6-airprint/
blogger_blog:
  - coding.zencoffee.org
blogger_author:
  - James Young
blogger_permalink:
  - /2012/11/centos-63-dnsmasq-cups-ios-6-airprint.html
categories:
  - Technical
tags:
  - linux
---
I finally decided to try and set up AirPrint to print from my iPhone 3GS running iOS 6 to my ancient HP LaserJet 4M+ .  As discussed before I'm running CentOS 6.3.  In addition, I've recently changed over my network infrastructure to use [DNSMASQ](http://www.thekelleys.org.uk/dnsmasq/doc.html) for providing DHCP/DNS.

Running AirPrint should in theory be pretty easy, since you can use [mDNS](http://en.wikipedia.org/wiki/Multicast_DNS) to publish the appropriate records through [Avahi](http://en.wikipedia.org/wiki/Avahi_(software)) and make it work (minor gripe - if you have to bang away at configuration files for hours to make something work, it is categorically not zero configuration!).  In practice however, my [Netcomm NB9WMAXXn](http://www.netcommwireless.com/product/voip/nb9wmaxxn) router is extremely flaky about multicast packets and generally won't pass them through the wireless.  My old [Billion 7404VGP](http://au.billion.com/product/voip/bipac7404vgp.php) that I now use as an access point in the shed has no such problems though.

This means I couldn't use mDNS.  I instead have to use [DNS-SD](http://www.dns-sd.org/).  So this article will describe how to set it up.  We'll make the following assumptions;

  * Your local domain is zencoffee.org
  * You wish to publish your DNS-SD records to dns-sd.zencoffee.org
  * Your cups server is at cups.zencoffee.org
  * You already have a working CUPS printer named 'LaserJet4MPlus'
  * You have already enabled remote administration for CUPS
  * You have added **ServerAlias *** at the top of your /etc/cups/cupsd.conf to allow hostnames to be used
  * Your CUPS printer is marked to be shared in the CUPS configuration

## Preparing CUPS to handle image/urf

iOS 6 will typically output print jobs in image/urf format.  By default, your printer won't accept that.  So we'll have to add some mime types and conversion filters to CUPS to make it work.

Edit /usr/share/cups/mime/airprint.types and enter;

<pre>image/urf urf string(0, UNIRAST )</pre>

This tells CUPS how to identify when incoming content is image/urf format.  Then, we need to define a conversion filter to tell CUPS how to convert image/urf to another format that it can handle.  Edit /usr/share/cups/mime/airprint.convs and enter;

<pre>image/urf application/pdf 100 pdftoraster</pre>

This tells CUPS how to convert image/urf to application/pdf.  If you now read mime.convs, you can see all the various transforms that CUPS can go through to generate a format that your printer can actually handle natively.

Restart the CUPS service.

## Getting AirPrint TXT records

Go to <https://github.com/tjfontaine/airprint-generate> and download airprint-generate.py and put it somewhere.  Then, run **yum install system-config-printer-libs** to install the Python CUPS libraries.

Run the Python script and you should get a .service file dropped into the current directory.  The one that I get is below;

<pre>AirPrint LaserJet4MPlus @ %h

    _ipp._tcp
    _universal._sub._ipp._tcp
    631    txtvers=1
    qtotal=1
    Transparent=T
    URF=none
    rp=printers/LaserJet4MPlus
    note=HP LaserJet 4M+
    product=(GPL Ghostscript)
    printer-state=3
    printer-type=0x823014
    pdl=application/octet-stream,application/pdf,application/postscript,image/gif,image/jpeg,image/png,image/tiff,image/urf,text/html,text/plain,application/vnd.cups-banner,application/vnd.cups-pdf,application/vnd.cups-postscript,application/vnd.cups-raw</pre>

This file is intended for insertion into Avahi, but we're going to use this info to generate DNS-SD records instead.

## Inserting DNS-SD Records into DNSMASQ

Now that we've got the data required and the print queue is ready, we need to insert all the records into DNSMASQ to make discovery work.  There are a number of records required to do this;

  * **Browse domain and Legacy Browse records.**  These tell DNS-SD clients where they can find the rest of the records.  In this case, our B and LB records will point clients to dns-sd.zencoffee.org .
  * **Internet Printing Protocol (IPP) Records.**  These define the IPP printer that we're creating.  You need both a regular IPP printer, and a special Universal Sub IPP printer definition for iOS devices to work.
  * **SRV Record for IPP Printer.**  This defines where the print queue can be found for the IPP printer (ie, it's hostname and port number).  In this case, it will be cups.zencoffee.org .
  * **TXT Record for IPP Printer.**  This defines all the required information about the IPP printer; capabilities, name, queue URL, type, supported mime types etc.  This record uses the info we got from airprint-generate.py above.

The following example from my dnsmasq configuration shows what I did;

<pre># Browse records (point DNS-SD clients to the DNS-SD domain)
ptr-record=b._dns-sd._udp,"dns-sd.zencoffee.org."
ptr-record=lb._dns-sd._udp,"dns-sd.zencoffee.org."
ptr-record=b._dns-sd._udp.zencoffee.org,"dns-sd.zencoffee.org."
ptr-record=lb._dns-sd._udp.zencoffee.org,"dns-sd.zencoffee.org."

# Descriptor for Airprint printer
ptr-record=_ipp._tcp.dns-sd.zencoffee.org,"Airprint_LaserJet4M_Plus._ipp._tcp.dns-sd.zencoffee.org."
ptr-record=_universal._sub._ipp._tcp.dns-sd.zencoffee.org,"Airprint_LaserJet4M_Plus._ipp._tcp.dns-sd.zencoffee.org."

# Where the print queue can be found
srv-host=Airprint_LaserJet4M_Plus._ipp._tcp.dns-sd.zencoffee.org,cups.zencoffee.org,631

# Parameters of printer
txt-record=Airprint_LaserJet4M_Plus._ipp._tcp.dns-sd.zencoffee.org,"txtvers=1","qtotal=1","Transparent=T","URF=DM3","rp=printers/LaserJet4MPlus","note=HP LaserJet 4M+","product=(GPL Ghostscript)","printer-state=3","printer-type=0x803014","pdl=application/octet-stream,application/pdf,application/postscript,image/gif,image/jpeg,image/png,image/tiff,image/urf,text/html,text/plain,application/vnd.cups-banner,application/vnd.cups-pdf,application/vnd.cups-postscript,application/vnd.cups-raw"</pre>

I have included the b and lb records for both the FQDN and the default domain.  They should both be the same, but I'm just covering off both bases.  My printer name has no spaces in it - you can probably use spaces in the printer name with \020, but I never tested that.

An important change to be made to the TXT record is to change the URF=none that airprint-generate.py adds to URF=DM3.  I don't know exactly what that means, but it makes it work.

Restart dnsmasq after adding all those records.

## Testing DNS-SD Resolution

After doing all of the above, the easiest way to test it out is to hit dig.  Here's an example of testing resolution;

<pre>[root@cups ~]# dig +noall +answer -t any b._dns-sd._udp
<strong>b._dns-sd._udp.         0       IN      PTR     dns-sd.zencoffee.org.</strong>
[root@cups ~]# dig +noall +answer -t any lb._dns-sd._udp
<strong>lb._dns-sd._udp.        0       IN      PTR     dns-sd.zencoffee.org.</strong>
[root@cups ~]# dig +noall +answer -t any _ipp._tcp.dns-sd.zencoffee.org
<strong>_ipp._tcp.dns-sd.zencoffee.org. 0 IN    PTR     Airprint_LaserJet4M_Plus._ipp._tcp.dns-sd.zencoffee.org.</strong>
[root@cups ~]# dig +noall +answer -t any _universal._sub._ipp._tcp.dns-sd.zencoffee.org
<strong>_universal._sub._ipp._tcp.dns-sd.zencoffee.org. 0 IN PTR Airprint_LaserJet4M_Plus._ipp._tcp.dns-sd.zencoffee.org.</strong>
[root@cups ~]# dig +noall +answer -t any Airprint_LaserJet4M_Plus._ipp._tcp.dns-sd.zencoffee.org
<strong>;; Truncated, retrying in TCP mode.
Airprint_LaserJet4M_Plus._ipp._tcp.dns-sd.zencoffee.org. 0 IN TXT "txtvers=1" "qtotal=1" "Transparent=T" "URF=DM3" "rp=printers/LaserJet4MPlus" "note=HP LaserJet 4M+" "product=(GPL Ghostscript)" "printer-state=3" "printer-type=0x803014" "pdl=application/octet-stream,application/pdf,application/postscript,image/gif,image/jpeg,image/png,image/tiff,image/urf,text/html,text/plain,application/vnd.cups-banner,application/vnd.cups-pdf,application/vnd.cups-postscript,application/vnd.cups-raw"
Airprint_LaserJet4M_Plus._ipp._tcp.dns-sd.zencoffee.org. 0 IN SRV 0 0 631 cups.zencoffee.org.</strong>
[root@cups ~]#</pre>

You can see all the appropriate records getting returned as they are supposed to.  All looks good.  Fire up the iThing and try and print!  If it doesn't work, then use **tcpdump -x port 53** to monitor DNS traffic, or **tcpdump -x port 631** to monitor traffic to the CUPS server.  You should see the iThing walk through the DNS records pretty much just like above.

If you see HTTP 400 errors being passed back from CUPS, be really sure you've put a ServerAlias * at the top of your cupsd.conf.

Barring all that, it should work.  Whee!

Next up, AirPrint through CUPS to a printer shared on a Windows machine...