---
id: 8
title: BusPirate AVRDude Patch Updated!
date: 2013-01-12T03:22:00+09:30
author: James Young
layout: post
guid: http://wordpress/wordpress/?p=8
permalink: /2013/01/buspirate-avrdude-patch-updated/
blogger_blog:
  - coding.zencoffee.org
blogger_author:
  - James Young
blogger_permalink:
  - /2013/01/buspirate-avrdude-patch-updated.html
categories:
  - Electronics
tags:
  - avrdude
  - buspirate
---
<div>
  <a href="https://i2.wp.com/www.adafruit.com/adablog/wp-content/uploads/2010/03/buspiratepcb_LRG.jpg"><img alt="" src="https://i2.wp.com/www.adafruit.com/adablog/wp-content/uploads/2010/03/buspiratepcb_LRG.jpg?resize=200%2C153" width="200" height="153" border="0" data-recalc-dims="1" /></a>
</div>

<span style="color: #ff0000;"><b>EDIT:  Patch updated again to remove the last of the warnings.  Also incorporated a fix to the progress bar and one to only put up the raw paged_load commands on verbosity > 1 - thanks to Nils Steinger for the fix!</b></span>

**<span style="color: #ff0000;">EDIT:  Patch has now been <a href="http://savannah.nongnu.org/patch/?7936"><span style="color: #ff0000;">integrated</span></a> into the official AVRDude SVN as per revision 1137 !  This means that any nightly builds of AVRDUDE should have the functionality built in, and the next release will have it!</span>  ** 

At the request of a reader, I've gone and updated the avrdude patch I wrote for the BusPirate to work with the latest SVN of AVRDUDE (release 1132 at this time).

A few changes were necessary, and notably the paged_load method is now slightly different.  At any rate, I've updated the versions of the files you can find in my GoogleCode Repository at [this link](http://code.google.com/p/zencoding-blog/source/browse/#svn%2Ftrunk%2Fbuspirate) to work.  The new avrdude-latest.zip is built from the latest SVN.

Notably, this was also built against the latest version of [libusb-win32](http://sourceforge.net/projects/libusb-win32/files/libusb-win32-releases/).

In order to test, the easiest thing to do is to grab the optiboot firmware for your Arduino out of the Arduino install (look for optiboot_atmega328.hex), then write it like this;

<pre>avrdude -v -p m328p -P COM4 -C avrdude.conf -c buspirate -U flash:w:optiboot_atmega328.hex</pre>

Verification of the bootloader takes 0.89 seconds.  Obviously substitude atmega328 with whatever type of ATmega you have, and substitute the COM4 for your serial port your BusPirate is attached to.

The command to dump the existing flash to a file is;

<pre>avrdude -v -p m328p -P COM4 -C avrdude.conf -c buspirate -U flash:r:firmware.hex:i</pre>

Full 32k flash verification takes 40.90 seconds. This should work fine with a 2560, although I haven't as yet had a chance to test.  Getting this updated patch out was a rush job to make it available.  I'll test with the 2560 before reposting to the AVRDUDE Developers.