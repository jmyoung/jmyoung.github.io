---
id: 68
title: 'Bus Pirate &#8211; 40x Verify Speed Increase!'
date: 2011-08-04T13:05:00+09:30
author: James Young
layout: post
guid: http://wordpress/wordpress/?p=68
permalink: /2011/08/bus-pirate-40x-verify-speed-increase/
blogger_blog:
  - coding.zencoffee.org
blogger_author:
  - DW
blogger_permalink:
  - /2011/08/bus-pirate-40x-verify-speed-increase.html
categories:
  - Electronics
tags:
  - avrdude
  - buspirate
---
<span><b>Update 19th April 2012 - I finally go an ATmega2560, so I fixed the code to work with memory paging and also updated the patches to work with all the latest versions of AVRDUDE and the Bus Pirate firmware.</b></span>  
<span><b>Update 12th January 2013 - Haven't touched this stuff in a while, but a reader informed me that the patch no longer works with the latest SVN.  I've updated it to work with the latest SVN (release 1132 as of this writing).</b></span>

Been messing about for the past day in trying to increase the speed of the Bus Pirate when acting as an ICSP programmer.  Basically, I didn't like the idea of waiting 15 minutes+ for a 32k flash to verify.

I did some examination of just how the BP works with AVRDUDE, and in the process learned a gory amount about SPI, binary bitbang on the Bus Pirate, and how to use SPI to talk to an Atmel MCU.

It turns out that the reason why the BP is so slow during the verify step is that it handles the whole SPI transaction through the UART, so it's sending/receiving up to 13 or so bytes per one byte that is coming out of the flash, and that's happening in multiple distinct synchronous transactions.  So there's a huge amount of delay, and that adds up to very slow performance.

The solution I had to this was to try and move the SPI transaction stuff directly onto the Bus Pirate.  First I coded up some stuff to use the BASIC scripting engine to run the SPI transactions.  It worked, but it was a little messy.  The final solution was to customize the firmware on the Bus Pirate to add a new set of commands in SPI bitbang mode, and then customize avrdude to detect the availability of those commands and make use of them.

Now it only takes ~30 seconds to verify a 32k flash, which is up to a 40x speed increase!  Read on for how to do it.

<a name="more"></a>

<span><b>The Bus Pirate Firmware</b></span>

  * The Bus Pirate source code -  <http://code.google.com/p/dangerous-prototypes-open-hardware/source/browse/#svn%2Ftrunk%2FBus_Pirate%2FFirmware>
  * Patch file for that source - <http://zencoding-blog.googlecode.com/svn/trunk/buspirate/buspirate-1676-avr-extended.patch>
  * Compiled firmware image - <http://zencoding-blog.googlecode.com/svn/trunk/buspirate/buspirate-1676-avr-extended.hex>

Working from the 6.1 firmware, I customized it to include some new commands in SPI bitbang mode.  Specifically, sending a 0x06 enters what I've termed "AVR Extended Commands" mode, which currently only has three subcommands;

  * **0x00** - Do nothing
  * **0x01** - Report the version of the AVR Extended Commands module, returns a 2-byte unsigned, MSB first.
  * **0x02** - AVR Bulk Memory Read, following 4 bytes (MSB first) is the starting offset where memory should be read (IN WORDS), following 4 bytes is the number of bytes to read.  returns a 0x01 for success and the data.

When you compile firmware with MPlab for the Bus Pirate, you need to do a Build All, and then export the .HEX using program addresses 0 through to 0xA7FF, and don't export configuration bits.  That will give you a .HEX that is useable and won't overwrite the bootloader.

For those who don't want to build their own, a pre-compiled firmware image is above.  Install it using the DS30 Loader like you would any other Bus Pirate firmware.

<span><b>AVRDude Customizations</b></span>

  * AVRDude Source Code - <http://download.savannah.gnu.org/releases/avrdude/>
  * Bus Pirate Enhancements by Tim Vaughan - <http://savannah.nongnu.org/patch/?7437>
  * AVR Extended Commands patch by me - <http://zencoding-blog.googlecode.com/svn/trunk/buspirate/avrdude-5.11-buspirate.patch>
  * Pre-compiled AVRDUDE with the above - <http://zencoding-blog.googlecode.com/svn/trunk/buspirate/avrdude-latest.zip>

Tim Vaughan has submitted a patch for inclusion into AVRDude which dramatically improves performance with several tasks as well as making AVRDude actually work with 6.1 Bus Pirate firmware.  I've used that patch, and then included enhancements by myself to implement the paged_load() method using the AVR Extended Commands in the Bus Pirate firmware.

You can disable the use of the new paged load method with the "nopagedread" extended parameter to avrdude.

When avrdude initializes, it will probe the Bus Pirate to discover whether it has the AVR Extended Commands installed.  If not, then no harm will be done (0x06 does nothing by default), and avrdude will carry on as it would normally.  If it is found, then the Extended Commands will be leveraged to greatly speed up flash read operations.