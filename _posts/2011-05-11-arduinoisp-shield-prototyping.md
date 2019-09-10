---
id: 96
title: 'ArduinoISP-Shield &#8211; Prototyping'
date: 2011-05-11T02:45:00+09:30
author: James Young
layout: post
guid: http://wordpress/wordpress/?p=96
permalink: /2011/05/arduinoisp-shield-prototyping/
blogger_blog:
  - coding.zencoffee.org
blogger_author:
  - DW
blogger_permalink:
  - /2011/05/arduinoisp-shield-prototyping.html
categories:
  - Electronics
tags:
  - arduino
---
As discussed in my [last post](http://zencoding.blogspot.com/2011/05/arduino-uno-as-isp.html), I intended to make up a [prototype shield](http://www.freetronics.com/products/protoshield-basic) in order to supply three main functions - ICSP programmer, breakout to allow ICSP programming off-board, and FTDI serial input to allow comms with the inserted Atmel chip.  This post will discuss how I went with the schematics and breadboarding of the planned device.  
<a name="more"></a>  
**<span>The Schematic</span>**

<table align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td>
      <a href="https://i2.wp.com/2.bp.blogspot.com/-rmJcdKmJ-5c/Tcs0mAc8T3I/AAAAAAAAAE8/aL4ybGYRC8Y/s1600/ArduinoISP_Shield_schematic.png" imageanchor="1"><img border="0" height="241" src="https://i1.wp.com/2.bp.blogspot.com/-rmJcdKmJ-5c/Tcs0mAc8T3I/AAAAAAAAAE8/aL4ybGYRC8Y/s320/ArduinoISP_Shield_schematic.png?resize=320%2C241" width="320"  data-recalc-dims="1" /></a>
    </td>
  </tr>
  
  <tr>
    <td>
      ArduinoISP-Shield Schematic
    </td>
  </tr>
</table>

You can get the Eagle schematic and PDF at my GoogleCode Repository [here](http://code.google.com/p/zencoding-blog/source/browse/#svn%2Ftrunk%2Farduino%2Farduinoisp_shield).  In essence, this shield is intended to function in a couple of modes;

  * **Onboard ICSP Programming** - In order to do this, plug the shield into an Arduino, then put an Atmel chip into the ZIF socket, and run ArduinoISP as you usually would.  FTDI and the ICSP outbound header should be disconnected. The LEDs will indicate programming status.
  * **Offboard ICSP Programming** - Plug the shield into an Arduino, then hook up an ICSP programming cable to the ICSP outbound header.  Run ArduinoISP as you usually would, and the LEDs will indicate programming status.  FTDI should be disconnected and the ZIF socket should be empty.  Note, this mode is for outbound ICSP (ie, the shield is burning a bootloader on something else), and you shouldn't have a chip in the ZIF socket.
  * **FTDI Link to ZIF Socket** - Plug an FTDI cable into the FTDI header, and make sure an Atmel chip is in the ZIF socket.  Make sure that the shield is not plugged into an Arduino.  You can connect an external ICSP programmer if you want.  You can now use the FTDI cable to communicate to the Atmel on the shield and upload sketches to it.

I'm not entirely sure what would happen if you plug in the FTDI link and the Arduino at the same time, since the VCC lines are tied together.  It might be bad, so don't do it.  If you are gonig to, then the power sources must come from the same place so they're at the same potential.  At any rate, there are a number of LED's and items on the shield, namely;

  * **Pin13** - Connected to Digital Pin 13 on the ZIF socket.  This is so if you upload the Blink sketch, you can see the Atmel blink the LED if the programming worked.
  * **Prog** - Lights up when the underlying ArduinoISP is burning a bootloader.
  * **Error** - Lights up and stays on when the underlying ArduinoISP had some kind of problem burning the bootloader.  This may blink when you first start a burn.
  * **HBeat** - Heartbeat.  When the ArduinoISP programmer is running, this light will fade on and off.
  * **RESET** - Reset for the ZIF socket.  Pressing this will reboot the Atmel in the ZIF socket.

Right, now the schematic's done, time to assemble the prototype!

**<span>The Prototype</span>**  
** <span></span>**  
I've greatly shortened the development cycle here, but essentially what I did was assemble the prototype in three parts - first assemble the Atmel onto a breadboard with the connecting components (capacitors, reset switch, LED, resonator).  Once that was verified to work, I then assembled the FTDI cable parts onto the board using the [FTDI Adapter](http://zencoding.blogspot.com/2011/05/ft232r-to-ftdi-cable-adapter.html) I wrote about earlier;

<table align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td>
      <a href="https://i1.wp.com/3.bp.blogspot.com/-GceNDmCPm88/Tcs4CQ1iaqI/AAAAAAAAAFE/dmp4iuSy2k8/s1600/ftdi_overview.JPG" imageanchor="1"><img border="0" height="240" src="https://i2.wp.com/3.bp.blogspot.com/-GceNDmCPm88/Tcs4CQ1iaqI/AAAAAAAAAFE/dmp4iuSy2k8/s320/ftdi_overview.JPG?resize=320%2C240" width="320"  data-recalc-dims="1" /></a>
    </td>
  </tr>
  
  <tr>
    <td>
      Arduino Breadboard & FTDI Adapter
    </td>
  </tr>
</table>

The Arduino-on-a-breadboard is at the top and the FTDI adapter is on the bottom breadboard.  Note that the upper breadboard is missing the reset switch - I wired that up later.  To start with I only had the 10k pullup and the 0.1uF capacitor on the reset line.  Running that, I verified that I could upload a sketch and have it work - for starters I used the Blink sketch.  All worked.  Great.

Next up is to disconnect the FTDI cable and set up the ArduinoISP to be able to burn the bootloader.  For this, I cheated a little.  Because it's on a breadboard, I just hooked up the Arduino direct to the ZIF socket as the schematic shows and ran it;

<table align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td>
      <a href="https://i1.wp.com/3.bp.blogspot.com/--tJCP-9ts58/Tcs3_r33TbI/AAAAAAAAAFA/ZILh8bx9lcI/s1600/icsp_overview.JPG" imageanchor="1"><img border="0" height="240" src="https://i0.wp.com/3.bp.blogspot.com/--tJCP-9ts58/Tcs3_r33TbI/AAAAAAAAAFA/ZILh8bx9lcI/s320/icsp_overview.JPG?resize=320%2C240" width="320"  data-recalc-dims="1" /></a>
    </td>
  </tr>
  
  <tr>
    <td>
      Arduino Breadboard & ArduinoISP
    </td>
  </tr>
</table>

Notice the three LEDs on the breadboard on the left - that's the ISP status LEDs.  You'll also notice that the reset switch is in place on the right breadboard.  Anyway, running that showed it all worked.  I was able to burn the bootloader through the Arduino GUI, and also by running AVRDUDE by hand like this;

> <span>C:\arduino\hardware\tools\avr\bin>avrdude -pm328p -cstk500v1 -b19200 -PCOM3 -v -C ..\etc\avrdude.conf</p> 
> 
> <p>
>   avrdude: Version 5.4-arduino, compiled on Oct 11 2007 at 19:12:32<br />         Copyright (c) 2000-2005 Brian Dean, http://www.bdmicro.com/
> </p>
> 
> <p>
>            System wide configuration file is "..\etc\avrdude.conf"
> </p>
> 
> <p>
>            Using Port            : COM3<br />         Using Programmer      : stk500v1<br />         Overriding Baud Rate  : 19200<br />         AVR Part              : ATMEGA328P<br />         Chip Erase delay      : 9000 us<br />         PAGEL                 : PD7<br />         BS2                   : PC2<br />         RESET disposition     : dedicated<br />         RETRY pulse           : SCK<br />         serial program mode   : yes<br />         parallel program mode : yes<br />         Timeout               : 200<br />         StabDelay             : 100<br />         CmdexeDelay           : 25<br />         SyncLoops             : 32<br />         ByteDelay             : 0<br />         PollIndex             : 3<br />         PollValue             : 0x53<br />         Memory Detail         :
> </p>
> 
> <p>
>                                     Block Poll               Page<br />      Polled<br />           Memory Type Mode Delay Size  Indx Paged  Size   Size #Pages MinW  Max<br />W   ReadBack<br />           ----------- ---- ----- ----- ---- ------ ------ ---- ------ ----- ---<br />-- ---------<br />           eeprom        65     5     4    0 no       1024    4      0  3600  36<br />00 0xff 0xff<br />           flash         65     6   128    0 yes     32768  128    256  4500  45<br />00 0xff 0xff<br />           lfuse          0     0     0    0 no          1    0      0  4500  45<br />00 0x00 0x00<br />           hfuse          0     0     0    0 no          1    0      0  4500  45<br />00 0x00 0x00<br />           efuse          0     0     0    0 no          1    0      0  4500  45<br />00 0x00 0x00<br />           lock           0     0     0    0 no          1    0      0  4500  45<br />00 0x00 0x00<br />           calibration    0     0     0    0 no          1    0      0     0<br /> 0 0x00 0x00<br />           signature      0     0     0    0 no          3    0      0     0<br /> 0 0x00 0x00
> </p>
> 
> <p>
>            Programmer Type : STK500<br />         Description     : Atmel STK500 Version 1.x firmware<br />         Hardware Version: 2<br />         Firmware Version: 1.18<br />         Topcard         : Unknown<br />         Vtarget         : 0.0 V<br />         Varef           : 0.0 V<br />         Oscillator      : Off<br />         SCK period      : 0.1 us
> </p>
> 
> <p>
>   avrdude: AVR device initialized and ready to accept instructions
> </p>
> 
> <p>
>   Reading | ################################################## | 100% 0.05s
> </p>
> 
> <p>
>   avrdude: Device signature = 0x1e950f<br />avrdude: safemode: lfuse reads as FF<br />avrdude: safemode: hfuse reads as DE<br />avrdude: safemode: efuse reads as 5
> </p>
> 
> <p>
>   avrdude: safemode: lfuse reads as FF<br />avrdude: safemode: hfuse reads as DE<br />avrdude: safemode: efuse reads as 5<br />avrdude: safemode: Fuses OK
> </p>
> 
> <p>
>   avrdude done.  Thank you.</span>
> </p></blockquote> 
> 
> <p>
>   Note that when using the Arduino IDE version of AVRDUDE, you need to point it at the config file, hence the command line above.  Anyway, that all worked.  I wanted to run AVRDUDE by hand because the Arduino IDE gives you no feedback besides "Yay, it worked!", which doesn't tell me quite enough.  I wanted to be really sure it actually worked.
> </p>
> 
> <p>
>   <b><span>Next Steps</span></b>
> </p>
> 
> <p>
>   Well, the prototype on breadboard works.  The next thing to do is to arrange all the parts onto a prototype shield to make sure it'll all fit, and then start assembly.
> </p>
> 
> <p>
>   Photos and blog post when it's done.
> </p>