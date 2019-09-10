---
id: 76
title: 'AeroQuad 2.4.2 &#8211; Barometer with the Uno'
date: 2011-07-08T11:55:00+09:30
author: James Young
layout: post
guid: http://wordpress/wordpress/?p=76
permalink: /2011/07/aeroquad-2-4-2-barometer-with-the-uno/
blogger_blog:
  - coding.zencoffee.org
blogger_author:
  - DW
blogger_permalink:
  - /2011/07/aeroquad-242-barometer-with-uno.html
categories:
  - Electronics
tags:
  - aeroquad
  - arduino
  - quadcopter
---
I picked up a [BMP-085](http://www.sparkfun.com/products/9694) barometer breakout board for my quadcopter last week.  I decided to pick up one because the new [AeroQuad 2.4.2](http://code.google.com/p/aeroquad/source/browse/#svn%2Ftrunk%2FAeroQuad) code is able to be compiled to support altitude hold _and_ be able to fit on an Arduino Uno.

However, there's an issue.  Apparently the version of the Optiboot bootloader that comes with the Uno has a bug in it where it reserves flash RAM equal to the biggest bootloader (~2k or so), even though Optiboot only takes up 512 bytes.  This means that if your sketch compiles to over ~30k, you can compile but you can't upload.  You get a very obtuse error message.

There's a way to fix this though.  Make use of the [ArduinoISP](http://zencoding.blogspot.com/2011/05/arduinoisp-completed.html) I made earlier to reflash the bootloader!

<a name="more"></a>There's a fixed version of Optiboot that allows upload, but I realized that I could upload the Aeroquad binaries directly to the Arduino and bypass the bootloader entirely, and then I could use the entire 32k flash (!).  Optiboot be damned.

In order to do this, you'll need to get hold of your compiled code in .HEX format.  The easy way to do this is to hit Ctrl-R in the Arduino IDE, then use Windows Explorer to browse to %TEMP% .  Look around for a folder called buildtmp.XXXXXX where XXXXXX is some random gibberish.  Inside of that will be a copy of all the AeroQuad code source files, a bunch of .o files, and a single .HEX file.  This is what you want.  Copy it somewhere.

After that's done, you can use avrdude in the Arduino IDE kit to flash the Arduino directly.  The following command assumes you're using the ArduinoISP and it's connected to COM4.  It also assumes that the .HEX file is in c:\arduino, and you've installed the Arduino IDE as displayed.



> <span>C:\arduino\hardware\tools\avr\bin>avrdude -pm328p -cstk500v1 -b19200 -PCOM4 -v -C ..\etc\avrdude.conf -e -U flash:w:\arduino\aeroquad.hex<br />avrdude: Version 5.4-arduino, compiled on Oct 11 2007 at 19:12:32<br />         Copyright (c) 2000-2005 Brian Dean, http://www.bdmicro.com/<br />         System wide configuration file is "..\etc\avrdude.conf"<br />         Using Port            : COM4<br />         Using Programmer      : stk500v1<br />         Overriding Baud Rate  : 19200<br />         AVR Part              : ATMEGA328P<br />         Chip Erase delay      : 9000 us<br />         PAGEL                 : PD7<br />         BS2                   : PC2<br />         RESET disposition     : dedicated<br />         RETRY pulse           : SCK<br />         serial program mode   : yes<br />         parallel program mode : yes<br />         Timeout               : 200<br />         StabDelay             : 100<br />         CmdexeDelay           : 25<br />         SyncLoops             : 32<br />         ByteDelay             : 0<br />         PollIndex             : 3<br />         PollValue             : 0x53<br />         Memory Detail         :<br />                                  Block Poll               Page                       Polled<br />           Memory Type Mode Delay Size  Indx Paged  Size   Size #Pages MinW  MaxW   ReadBack<br />           ----------- ---- ----- ----- ---- ------ ------ ---- ------ ----- ----- ---------<br />           eeprom        65     5     4    0 no       1024    4      0  3600  3600 0xff 0xff<br />           flash         65     6   128    0 yes     32768  128    256  4500  4500 0xff 0xff<br />           lfuse          0     0     0    0 no          1    0      0  4500  4500 0x00 0x00<br />           hfuse          0     0     0    0 no          1    0      0  4500  4500 0x00 0x00<br />           efuse          0     0     0    0 no          1    0      0  4500  4500 0x00 0x00<br />           lock           0     0     0    0 no          1    0      0  4500  4500 0x00 0x00<br />           calibration    0     0     0    0 no          1    0      0     0     0 0x00 0x00<br />           signature      0     0     0    0 no          3    0      0     0     0 0x00 0x00<br />         Programmer Type : STK500<br />         Description     : Atmel STK500 Version 1.x firmware<br />         Hardware Version: 2<br />         Firmware Version: 1.18<br />         Topcard         : Unknown<br />         Vtarget         : 0.0 V<br />         Varef           : 0.0 V<br />         Oscillator      : Off<br />         SCK period      : 0.1 us<br />avrdude: AVR device initialized and ready to accept instructions<br />Reading | ################################################## | 100% 0.04s<br />avrdude: Device signature = 0x1e950f<br />avrdude: safemode: lfuse reads as FF<br />avrdude: safemode: hfuse reads as DE<br />avrdude: safemode: efuse reads as 5<br />avrdude: erasing chip<br />avrdude: reading input file "\arduino\aeroquad.hex"<br />avrdude: input file \arduino\aeroquad.hex auto detected as Intel Hex<br />avrdude: writing flash (31406 bytes):<br />Writing | ################################################## | 100% 36.19s<br />avrdude: 31406 bytes of flash written<br />avrdude: verifying flash memory against \arduino\aeroquad.hex:<br />avrdude: load data flash data from input file \arduino\aeroquad.hex:<br />avrdude: input file \arduino\aeroquad.hex auto detected as Intel Hex<br />avrdude: input file \arduino\aeroquad.hex contains 31406 bytes<br />avrdude: reading on-chip flash data:<br />Reading | ################################################## | 100% 36.03s<br />avrdude: verifying ...<br />avrdude: 31406 bytes of flash verified<br />avrdude: safemode: lfuse reads as FF<br />avrdude: safemode: hfuse reads as DE<br />avrdude: safemode: efuse reads as 5<br />avrdude: safemode: Fuses OK<br />avrdude done.  Thank you.</p> 
> 
> <p>
>   C:\arduino\hardware\tools\avr\bin></span>
> </p></blockquote> 
> 
> <p>
>   <span><br /></span><br /><span>Ta-da!  Afte</span>r that's finished, you should have the AeroQuad code running on a Uno, with no bootloader.  One advantage with this technique is I'm pretty sure you can compile it to have BatteryMonitor, AltitudeHold <i>and</i> use DCM instead of ARG, which is a better flight algorithm.
> </p>
> 
> <p>
>   Flight testing on the weekend 🙂
> </p>