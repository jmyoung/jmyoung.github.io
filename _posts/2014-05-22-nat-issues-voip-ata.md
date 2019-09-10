---
id: 745
title: NAT issues with VOIP ATA
date: 2014-05-22T16:13:27+09:30
author: James Young
layout: post
guid: http://blog.zencoffee.org/?p=745
permalink: /2014/05/nat-issues-voip-ata/
categories:
  - Computers
  - Technical
---
Well, my VOIP ATA has been working just fine for the past few weeks.  Except for yesterday.  My ADSL modem lost sync and therefore gained a new external IP address, and there the problems started.  From that point on, my ATA could not register with my SIP provider.  I even rebooted the ATA, and it made no difference.

The source of the problem appears to have been a long-standing bug with many of these types of routers.  When the external IP address changes, the NAT translation tables are not flushed.  Therefore, my ATA would have been continually trying to send UDP packets to the SIP provider, keeping the NAT table entry alive, but the packets were never getting back to it because the external IP didn't match any more!

Temporary solution was to reboot the router.  The bigger solution was to switch the damned thing over to bridge mode and install another router with OpenWRT.  More on that soon.