---
id: 71
title: Bus Pirate as ICSP Programmer
date: 2011-07-28T03:04:00+09:30
author: James Young
layout: post
guid: http://wordpress/wordpress/?p=71
permalink: /2011/07/bus-pirate-as-icsp-programmer/
blogger_blog:
  - coding.zencoffee.org
blogger_author:
  - DW
blogger_permalink:
  - /2011/07/bus-pirate-as-icsp-programmer.html
categories:
  - Electronics
tags:
  - arduino
  - avrdude
  - buspirate
---
<span style="color: #ff0000;"><b>NOTE:  This article was written for the Arduino 022 IDE, not for the release 1.0.  Things are now quite a lot simpler in the 1.0 IDE, so this article will be getting a severe editing once I get to retest everything.  Stay tuned.</b></span>

As discussed in my last post, I got a [Bus Pirate](http://dangerousprototypes.com/docs/Bus_Pirate) yesterday.  One of the first things I wanted to do with it was use it as an ICSP programmer for an [ATtiny85](http://www.sparkfun.com/products/9378).  The ATtiny85 is an 8-pin microcontroller with (up to) 6 I/O lines and 4 ADC's.  It can run up to 20MHz with an external crystal or 8MHz with its own internal oscillator.  It has 8k of flash available.

In this post, we'll discuss hooking it up to the Bus Pirate, getting the BP talking to Avrdude, setting up the efuses to use the internal oscillator, and then configuring the Arduino IDE so you can upload to it through the BP.**  
**  
**<span style="color: #ff0000;">Caution:  The BusPirate is <i>really really slow</i> as an ICSP programmer.  It'll work, but it may take 15 minutes to write and verify the default bootloader on an ATmega328p due to the large flash size.  On an ATmega2650 it might take an hour.  Be patient.  Or use the customized AVRDUDE and BP firmware I discuss</span> [here](http://zencoding.blogspot.com/2011/08/bus-pirate-40x-verify-speed-increase.html)<span style="color: #ff0000;">.</span>**

# **Step 1 - Connecting the BP to the ATtiny85**

Resources:

  * [http://dangerousprototypes.com/docs/Bus\_Pirate\_AVR_Programming](http://dangerousprototypes.com/docs/Bus_Pirate_AVR_Programming)
  * <http://tinkerlog.com/2009/06/18/microcontroller-cheat-sheet/>
  * [http://dangerousprototypes.com/docs/Common\_Bus\_Pirate\_cable\_pinouts](http://dangerousprototypes.com/docs/Common_Bus_Pirate_cable_pinouts)

As it turned out, hooking up the BP to the ATtiny is pretty easy.  Just follow the pinouts on the Microcontroller Cheat Sheet;

<table cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td>
      <a href="https://i0.wp.com/tinkerlog.com/wordpress/wp-content/uploads/2009/06/micro-cheat-sheet.png"><img alt="" src="https://i0.wp.com/tinkerlog.com/wordpress/wp-content/uploads/2009/06/micro-cheat-sheet.png?resize=251%2C320" width="251" height="320" border="0" data-recalc-dims="1" /></a>
    </td>
  </tr>
  
  <tr>
    <td>
      Microcontroller Cheat Sheet (link above)
    </td>
  </tr>
</table>

Pay particular attention to the fact that the BusPirate I/O header layout on the sheet above is actually reversed compared to the Seeedstudio layout.  Use the pin names and colour reference instead to determine which pin is which;

<table cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td>
      <a href="https://i2.wp.com/dangerousprototypes.com/docs/images/1/1a/Seed-cable.png"><img alt="" src="https://i2.wp.com/dangerousprototypes.com/docs/images/1/1a/Seed-cable.png?resize=320%2C196" width="320" height="196" border="0" data-recalc-dims="1" /></a>
    </td>
  </tr>
  
  <tr>
    <td>
      Color Reference - MISO is pin 10, GND is pin 1
    </td>
  </tr>
</table>

Going from those two, it's pretty straightforward to wire up the ATtiny85 as follows;

<div class="table-responsive">
  <table  style="width:100%; "  class="easy-table easy-table-default " border="0">
    <tr>
      <th >
        BusPirate Label
      </th>
      
      <th >
        BP Color
      </th>
      
      <th >
        ATtiny85 Tag
      </th>
      
      <th >
        AT Pin
      </th>
    </tr>
    
    <tr>
      <td >
        GND
      </td>
      
      <td >
        Brown
      </td>
      
      <td >
        GND
      </td>
      
      <td >
        4
      </td>
    </tr>
    
    <tr>
      <td >
        +5V
      </td>
      
      <td >
        Orange
      </td>
      
      <td >
        Vcc
      </td>
      
      <td >
        8
      </td>
    </tr>
    
    <tr>
      <td >
        CS
      </td>
      
      <td >
        White
      </td>
      
      <td >
        RESET
      </td>
      
      <td >
        1
      </td>
    </tr>
    
    <tr>
      <td >
        MOSI
      </td>
      
      <td >
        Grey
      </td>
      
      <td >
        MOSI
      </td>
      
      <td >
        5
      </td>
    </tr>
    
    <tr>
      <td >
        MISO
      </td>
      
      <td >
        Black
      </td>
      
      <td >
        MISO
      </td>
      
      <td >
        6
      </td>
    </tr>
    
    <tr>
      <td >
        CLK
      </td>
      
      <td >
        Purple
      </td>
      
      <td >
        SCK
      </td>
      
      <td >
        7
      </td>
    </tr>
  </table>
</div>

After the BusPirate is all wired up, it's time to set up a new version of avrdude to work with it.

# **Step 2 - Setting up the new avrdude**

Resources:

  * [http://dangerousprototypes.com/docs/Bus\_Pirate\_AVR_Programming](http://dangerousprototypes.com/docs/Bus_Pirate_AVR_Programming)
  * <http://zencoding-blog.googlecode.com/svn/trunk/buspirate/avrdude-latest.zip>

Unfortunately, the version of avrdude that comes with the Arduino 22 IDE is positively ancient and doesn't support the Bus Pirate.  The latest 5.10 version of avrdude does, so you'll need that.  You can pick up a pre-compiled binary from [here](http://zencoding-blog.googlecode.com/svn/trunk/arduino/avrdude-latest.zip).  Extract out the files.

Pop open a command prompt, go to the folder that you put this new version of avrdude in, and then run the following command;

<pre>avrdude -c buspirate -P COM8 -p t85 -v</pre>

You should see a whole bunch of useful info, and most importantly you should see a list of the fuse settings.  If so, fantastic, it works!

# **Step 2a - Building your own AVRDUDE**

Resources:

  * <http://tomeko.net/other/avrdude/building_avrdude.php>
  * <http://download.savannah.gnu.org/releases/avrdude/>
  * <http://savannah.nongnu.org/patch/?7437>

This is an advanced step.  You don't need to do this if you want to use my pre-compiled AVRDUDE in Step 2.  But if you want to build your own, follow these instructions to make it easy(ish).

  * Download and install MINGW and MSYS.
  * Use TortoiseSVN to fetch the latest AVRDUDE into C:\MinGW\msys\1.0\home\\avrdude
  * Download the latest libusb-win32 from <http://sourceforge.net/projects/libusb-win32/files/libusb-win32-releases/1.2.5.0/libusb-win32-bin-1.2.5.0.zip/download> 
      * From include\usb.h in that package, copy that to C:\MinGW\include and rename as usb.h
      * From lib\gcc\libusb.a, copy that to C:\MinGW\lib
      * From bin\x86\libusb0_x86.dll, copy that to C:\MinGW\bin, and rename as libusb0.dll
      * Drop a copy of libusb0.dll into your avrdude repository.
  * Update MinGW and install additional components
  * mingw-get update 
      * mingw-get install autoconf
      * mingw-get install automake
      * mingw-get install msys-bison
      * mingw-get install msys-flex
      * mingw-get install msys-patch

  * Get and install the BusPirate patch for the AVRDUDE SVN 
      * Download the patch file from the link above, and copy it into C:\MinGW\msys\1.0\home\
      * In mingw, do the following; 
          * cd avrdude
          * patch < ../avrdude_buspirate.patch
      * You should now have a patched AVRDude, which has some optimizations to make it work a lot faster than default.
  * Configure and build 
      * ./bootstrap
      * ./configure
      * make
      * strip avrdude.exe
  * Now, copy out the following files, they make your new avrdude; 
      * libusb0.dll
      * avrdude.exe
      * avrdude.conf

<div>
  <h1>
    <b>Step 3 - Programming Fuses on the ATtiny85</b>
  </h1>
</div>

Resources:

  * <http://frank.circleofcurrent.com/fusecalc/fusecalc.php?chip=attiny85>

Next up, we're going to want to set the fuses on the ATtiny85 to suit what we want to do.  In my case, I want to run at 8MHz using the internal oscillator.  Using the link above, this means I want to set the lfuse to 0x62 and the hfuse to 0xDF.  In my particular case, the fuses are set correctly by default, but if they weren't you could reconfigure them with;

<pre>avrdude -c buspirate -P COM8 -p t85 -v -U lfuse:w:0x62:m -U hfuse:w:0xDF:m</pre>

Note that the default fuses will set the ATtiny85 to use the internal RC oscillator and divide it by 8.  This means that your ATtiny will actually run at 1MHz.  If that suits your task, fantastic - it'll draw less power that way.  I'm leaving things at default just for the sakes of making it work.  If you do turn off CKDIV8 to get an 8MHz clock, you'll have to change attiny85buspirate.build.f_cpu below to 8000000L to suit.

And now, a warning.  It's possible to brick your ATtiny by setting the wrong fuses.  In particular, if you set RSTDISBL=0 (ie, enable the reset pin to be used as an I/O pin), you remove the ability to be able to program the ATtiny with a normal ISP, and you'll have to use a high voltage programmer in order to fix it.  So don't do that unless you are _really sure_ your code is going to work and you really need that sixth I/O.

Anyway, set the fuses as required, and then we're going to integrate it all into the Arduino IDE.

# **Step 4 - Arduino IDE Integration**

Resources:

  * <http://hlt.media.mit.edu/wiki/pmwiki.php?n=Main.ArduinoATtiny4585>

First off, we'll need to copy in our compiled avrdude.  Fortunately, the cygwin1.dll is compatible between the version 22 IDE and the avrdude linked above.  Assuming you installed the IDE into c:\arduino, copy avrdude.exe, libusb0.dll, cygusb0.dll and cygwin1.dll into c:\arduino\hardware\tools\avr\bin .  Then copy your avrdude.conf into c:\arduino\hardware\tools\avr\bin .

Next up, you'll need to reconfigure your default Arduino boards so that you can upload using the new avrdude (which requires programmer type 'arduino' instead of 'stk500').  To do this, copy c:\arduino\hardware\arduino to the hardware folder in your sketchbook, so you have a folder hardware\arduino in your sketchbook.  This causes that new copy of the Arduino platform definition to override the built-in version in your IDE.  Edit programmers.txt and comment out (put #'s at the start) of any lines for programmers you don't have, and then edit boards.txt and comment out any boards you don't have.  For the Arduino Uno board, edit the uno.upload.protocol line and change it to read uno.upload.protocol=arduino .  This causes the IDE to use programmer type "arduino" when calling AVRdude, which is correct.

Download [attiny45_85.zip](http://hlt.media.mit.edu/wiki/uploads/Main/attiny45_85.zip) from the link above.  Follow the instructions in that link in order to extract out the attiny45_85 folder into your hardware folder.  Then, edit your boards.txt file that you extracted.  What you'll need to do here is to comment out (add #'s at the beginning of the line) any of the options you don't care about, and add in a new one.  The new option we're adding down the bottom is like this;

<pre>attiny85buspirate.name=ATtiny85 (w/ BusPirate)
attiny85buspirate.upload.using=attiny45_85:buspirate
attiny85buspirate.upload.maximum_size=8192
attiny85buspirate.build.mcu=attiny85
attiny85buspirate.build.f_cpu=1000000L
attiny85buspirate.build.core=attiny45_85</pre>

Next, you'll need to create a programmers.txt in the same folder as your boards.txt, and set its content to the following;

<pre>buspirate.name=BusPirate
buspirate.communication=serial
buspirate.protocol=buspirate</pre>

Once that's done, you should be set up.  Fire up the Arduino IDE, and in the Board selection, you should see your new "ATtiny85 (w/ BusPirate)" option.

# **Step 5 - Testing!**

Resources:

  * <http://dangerousprototypes.com/docs/Bitbang>

We're nearly home free.  Fire up the Arduino IDE, and open the Blink sketch.  Change any references to pin 13 to 0.  Pin 0 corresponds to physical pin 5 on the ATtiny85, and is the MOSI line on the chip.  That line corresponds to BusPirate pin 8, which is what we'll be looking at shortly.

Upload the sketch.  You should see some Cygwin warnings, and then a line about putting the BusPirate into binary mode.  You should see nothing else (the IDE is a little quiet, unfortunately).

After that's done, hopefully everything will work.  In order to avoid having to go as far as pulling out the ATtiny85 and hooking a LED to it, we'll utilize the BusPirate to monitor that line toggling!

Using a terminal client of some type, connect to the BusPirate.  You should be in Hi-Z mode.  Type "m9" and hit enter to go into Direct I/O mode.  Hit 'v' and press enter and you should see all the connected lines in state "I" (input).  That's what we want.  Now, type "pW" and press enter.  This disables the internal pullups if they happen to be on, and then turns on the power supplies.  This will cause the ATtiny85 to power up and (hopefully!) start pulsing pin 8 on the BusPirate.

Now, type "v" and press enter a few times, and you should see pin 8's state transition from L (low) to H (high).  If that happened, then that indicates that the ATtiny85 has been successfully programmed with your code from the Arduino IDE!

Coming up soon, some optimizations to AVRdude to make it work faster (I hope).