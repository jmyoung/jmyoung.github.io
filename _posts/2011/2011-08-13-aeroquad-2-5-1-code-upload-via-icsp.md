---
id: 67
title: 'AeroQuad 2.5.1 &#8211; Code Upload via ICSP'
date: 2011-08-13T03:52:00+09:30
author: James Young
layout: post
guid: http://wordpress/wordpress/?p=67
permalink: /2011/08/aeroquad-2-5-1-code-upload-via-icsp/
blogger_blog:
  - coding.zencoffee.org
blogger_author:
  - DW
blogger_permalink:
  - /2011/08/aeroquad-251-code-upload-via-icsp.html
categories:
  - Quadcopters
tags:
  - aeroquad
  - arduino
  - avrdude
  - buspirate
---
So I've been fooling with the new AeroQuad 2.5.1 code, and I've integrated some fixes posted by Kenny9999 (an AeroQuad.com forum user), as well as integrated my battery level compensation code.  Unfortunately though, putting in both makes the code a _little_ too big to fit into the 32256 bytes you have available on the Uno with the Optiboot bootloader.

Since I have an ICSP programmer (Bus Pirate to the rescue!) I decided I'd go and upload the code directly.  That way I can utilize the entirety of the flash!

<a name="more"></a>

As discussed in my post about using a [Bus Pirate as an ICSP programmer](http://zencoding.blogspot.com/2011/07/bus-pirate-as-icsp-programmer.html), you need to set up a new hardware definition for Arduino.  Mine's called tiny45_85, but we'll use that for a new ATmega328p definition.

Edit boards.txt in tiny45_85, and add the following;

<pre>atmega328p16mhzbuspirate.name=ATmega328p 16MHz (w/ BusPirate)
atmega328p16mhzbuspirate.upload.using=attiny45_85:buspirate
atmega328p16mhzbuspirate.upload.maximum_size=32760
atmega328p16mhzbuspirate.build.mcu=atmega328p
atmega328p16mhzbuspirate.build.f_cpu=16000000L
atmega328p16mhzbuspirate.build.core=arduino:arduino</pre>

Essentially what this does is create a new entry in the Arduino IDE's "Boards" menu, which will upload using the Bus Pirate programmer definition we made in attiny45_85/programmers.txt, setting the maximum upload size to 32760 bytes at 16MHz.  It will use the build core for a normal Arduino.

What's notable is that the default fuse setup for an Arduino ([here](http://frank.circleofcurrent.com/fusecalc/fusecalc.php?chip=atmega328p&LOW=FF&HIGH=D6&EXTENDED=05&LOCKBIT=FF)) will set the high fuse to 0xD6.  This sets up the Arduino so on boot it will boot the bootloader.  In other words, code execution will not begin at address 0x0000.  This won't work if you have no bootloader.  The fuses need to be changed so that the BOOTRST flag is _unprogrammed_.  In AVR-speak, this means it's set to a value of 1 (0 means "programmed).  So, this means that the high fuse needs to be set to 0xD7.  No other fuses need to be changed.

To change this, you'll need to run AVRDUDE with a command line like this;

<pre>avrdude -p m328p -c buspirate -P COM8 -v -C ..\etc\avrdude.conf -U lfuse:w:0xFF:m -U hfuse:w:0xD7:m -U efuse:w:0x05:m</pre>

Once I figure out exactly how to do it through the IDE, I'll integrate that into boards.txt above and edit this post.  If you don't change that fuse, your code _might_ work, since the flash will by default be filled up with 0xFF's, but if your code happens to be big enough to go into where the boot is trying to start, it probably won't work.  Set the fuses right.

After that's all done, you should be able to fire up your Arduino IDE, and see a new entry in Boards called "ATmega328p 16MHz (w/ BusPirate)".  Select that as the target board, upload and voila!  Your code will be burned directly onto the ATmega328p with no bootloader through ICSP.

I'd suggest that you use the bootloader (since then you can use the built in USB upload) unless you have specific reasons not to (eg, pin state on boot causes the bootloader to lock up, or you need the space).