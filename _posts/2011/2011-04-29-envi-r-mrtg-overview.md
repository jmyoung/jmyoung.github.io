---
id: 105
title: 'ENVI-R &amp; MRTG &#8211; Overview'
date: 2011-04-29T02:46:00+09:30
author: James Young
layout: post
guid: http://wordpress/wordpress/?p=105
permalink: /2011/04/envi-r-mrtg-overview/
blogger_blog:
  - coding.zencoffee.org
blogger_author:
  - DW
blogger_permalink:
  - /2011/04/envi-r-mrtg-overview.html
categories:
  - Technical
tags:
  - envir
  - linux
---
I recently had an [ENVI-R](http://www.currentcost.com/product-envir.html) wireless power monitor installed, and I set it up to record data to an always-on Ubuntu Linux box I have sitting around using [MRTG](http://oss.oetiker.ch/mrtg/).  The setup required a fair bit of scripting in Perl, Bash, and a couple of extra bits of software.

This post is the first in a series outlining just how I set up the monitor and what was required.  
<a name="more"></a>  
<span>The ENVI-R and accessories</span>

I bought the [ENVI-R](http://www.currentcost.com/product-envir.html) unit in a pack which included the transmitter, a receiver LCD display, power supply and one current clamp.  I also bought an additional two current clamps and the USB connector cable for the receiver.

The USB connector is actually a specially wired Prolific PL2303 USB to RS232 serial port adapter, with an RJ45 connector on the end.  I don't know the exact pinout, but that's not required.  Anyway, the adapter "just works" with Ubuntu 10.10.

Each transmitter unit can handle up to three current clamps, and one receiver can handle up to ~10 transmitters.  I didn't want to buy additional transmitters, and there isn't a huge amount of space in my switchboard, so I just got an additional two current clamps bringing me to three.  That allows for the monitoring of up to three loads.

<span>Clamp Installation</span>

<div>
  <b>WARNING - Mains voltage can be lethal.  In addition, tampering with your switchboard without an electrician's license may be illegal, as well as dangerous.  Get an electrician to install the clamps for you.</b>
</div>

The clamps themselves are no-contact types, and go around the active wire of whatever feed you want to monitor.  They should be clamped entirely around the wire so that the ferrite core of the clamp encircles the active wire.  The clamp operates by picking up the EM field around the active wire as current passes.

Be aware that the clamp cannot identify the direction that current is flowing.  This isn't a problem in the case of a house like mine that has no solar power, but if you have solar power you'll want to install a clamp onto the feed coming from the solar cells, and then put your main power clamp after the location where the solar power feed connects to your main feed.

In my case, my electric hot water is on a different circuit from the main power, so the three clamps were connected as so;

  * Main power:  Clamp connected after main breaker, between breaker and switchboard.  Registers all power going into the house (except hot water)
  * Lights:  Clamp connected after breaker for the lights (I only have one).
  * Hot water:  Clamp connected after breaker for the hot water.

Be aware as well that the ENVI-R assumes if you have multiple clamps connected to one transmitter that you're measuring 3-phase power, and it therefore just adds together all the currents.  In the case of mains + hot water that's OK, but since my "main" clamp is actually registering the sum of lights and everything else, it'll over-read if the lights are on.  For that reason, if you're setting up like me, don't trust the display, use the serial data feed.

<span>ENVI-R Receiver Installation</span>

The receiver is pretty straightforward, and it's just plugged in, and then the USB serial cable is hooked up.  I'll run through the software to actually interpret the data in a useable format for MRTG later.

The ENVI-R communicates at 57600 8N1 speed.  If you want to just see the raw output, run this command from the command line;

> $ stty -F /dev/ttyUSB0 speed 57600  
> $ cat /dev/ttyUSB0

You should see, about once every five seconds, output something like this;

> <msg><src>CC128-v1.31</src><dsb>00022</dsb><time>09:30:36</time><tmpr>22.0</tmpr><sensor>0</sensor><id>03322</id><type>1</type><ch1><watts>00000</watts></ch1><ch2><watts>00291</watts></ch2><ch3><watts>00000</watts></ch3></msg>

If you do, great.  The ENVI-R is all hooked up.  Note that it also monitors temperature, and that temperature is the temperature of the receiver.  Note, if you don't have a transmitter attached, you won't see any output from the ENVI-R at all.

<span>The Software</span>

For this kind of thing, most people seem to use Cacti.  While it's definite that Cacti can do more, the box I'm using has very limited memory, so I need to keep the number of running daemons to an absolute minimum.  MRTG can run as a Cron job, and doesn't require a database daemon to be running as well.  For the small number of graphs I'm talking, Cacti is overkill.

In order to pass data to MRTG, I used a message broker written by IBM ([Really Small Message Broker](http://www.alphaworks.ibm.com/tech/rsmb)), since it does the job and it's tiny.  Then I wrote a couple of Perl scripts to handle converting the raw ENVI-R data into moving averages for MRTG to slurp up.  So, the software required is;

  * IBM's [RSMB](http://www.alphaworks.ibm.com/tech/rsmb) or other MQTT-compatible message broker
  * [MRTG](http://oss.oetiker.ch/mrtg/) for generating the graphs
  * A web server of some type.  I used [THTTPD](http://www.acme.com/software/thttpd/), since it's very small and fast.
  * Perl.  It'll come with Ubuntu, but you will need a number of CPAN libraries.

<span>Up Next</span>

If you get to this point, you should have a connected up ENVI-R with a few clamps, and it should be hurling data out to /dev/ttyUSB0 on your Linux recording box.  Fantastic.

Now for the software....