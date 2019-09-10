---
id: 78
title: 'ArduinoISP &#8211; Burning the default fuses for an ATmega328p'
date: 2011-07-01T13:46:00+09:30
author: James Young
layout: post
guid: http://wordpress/wordpress/?p=78
permalink: /2011/07/arduinoisp-burning-the-default-fuses-for-an-atmega328p/
blogger_blog:
  - coding.zencoffee.org
blogger_author:
  - DW
blogger_permalink:
  - /2011/07/arduinoisp-burning-default-fuses-for.html
categories:
  - Electronics
tags:
  - arduino
  - avrdude
---
When you buy a brand new, blank ATmega328p, it comes with a set of fuses (basically hardware settings) which give it maximum reliability, but they aren't the default that is required for the chip to work with the Arduino IDE and libraries.  In order to burn the correct fuses onto it, run the following command (this assumes that you're using Arduino-as-ISP on COM4);

<pre>avrdude -pm328p -cstk500v1 -b19200 -PCOM4 -v -C ..\etc\avrdude.conf -U lfuse:w:0xFF:m -U hfuse:w:0xD6:m -U efuse:w:0x05:m</pre>

<div>
  Run the command from the hardware\tools\avr\bin directory inside your Arduino IDE install.
</div>

<div>
</div>

<div>
  Short post, I know.  This info's mostly for my reference, but should be handy for others too.
</div>