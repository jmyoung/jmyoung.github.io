---
id: 102
title: 'MCE Remote &#8211; IR Blaster Prototyping'
date: 2011-05-04T02:50:00+09:30
author: James Young
layout: post
guid: http://wordpress/wordpress/?p=102
permalink: /2011/05/mce-remote-ir-blaster-prototyping/
blogger_blog:
  - coding.zencoffee.org
blogger_author:
  - DW
blogger_permalink:
  - /2011/05/mce-remote-ir-blaster-prototyping.html
categories:
  - Electronics
tags:
  - arduino
  - htpc
---
I'm currently forced to use three remote controls, and I don't particularly want to shell out for a [Logitech Harmony](http://www.logitech.com/en-au/remotes/universal-remotes) universal remote. So, I got the idea to construct an IR relay myself, which would pick up signals from the Media Center Remote (the one that I use all the buttons for), and then be able to replicate the functionality of the two remotes that I only use power bottons on.

<a name="more"></a>  
Why not just buy the universal?  This is for a couple of reasons;

  * I'd have to instruct my wife on how to use the thing, and she's only just gotten used to using the [Hauppauge Media Center Remote](http://store.hauppauge.com/accessories2.asp?product=mce_remote) I currently have.
  * The Hauppauge remote has an IR blaster built in, but I (probably) can't use it for this kind of purpose.
  * It's a good learning opportunity.
  * It will cost under $20 in parts, whereas a Logitech Harmony is pretty expensive.
  * I don't want an expensive remote mauled by the baby.
  * And likewise, I don't want an expensive remote eaten by my dog.  Seriously.  This dog chewed a palm tree off at ground level.  An expensive remote control would be a tasty snack.

So, doing a bit of digging around, I came across [Ken Shirriff's blog](http://www.arcfn.com/2009/08/multi-protocol-infrared-remote-library.html) and the IRremote library he wrote.  Exactly what I need!

So, consulting his demo programs, I assembled some hardware as follows;

  * An IR Receiver.  I got a [ZD1952 IR Receiver](http://jaycar.com.au/productView.asp?ID=ZD1952) from Jaycar, since it's multi-frequency and outputs TTL.  Connecting the pins up as per the datasheet to +5V and GND, the signal pin goes to Digital Pin 5 (for my program, it's 11 for Ken's demos).
  * An IR LED.  I used a [ZD1945 5mm IR LED](http://jaycar.com.au/productView.asp?ID=ZD1945) from Jaycar.  Initially I used a 100 ohm resistor in series to ground from the LED, and connected the LED to Digital Pin 3 on the Arduino.  Later I made a driving circuit with a transistor for the LED.  For testing, I replaced the IR LED with a normal 5mm LED so I could see if anything happened.
  * An RGB LED.  I used the RGB LED that came with the Sparkfun kit, but something like this [ZD0012 RGB LED](http://jaycar.com.au/productView.asp?ID=ZD0012) should be suitable.  Remember to use something like a 330 ohm series resistor with it to avoid blowing anything up.  The red pin attaches to digital pin 9, the green to digital pin 10, and the blue to digital pin 11.

Assembling the hardware together and using Ken's demo programs, the first step required is to discover what is emitted by my current remotes when their buttons are pressed.

<table align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td>
      <a href="https://i2.wp.com/4.bp.blogspot.com/-qiVkXksBF9c/TcHPfQ7edXI/AAAAAAAAAEc/axHlf9resQ4/s1600/MPC_breadboard.JPG" imageanchor="1"><img border="0" height="245" src="https://i1.wp.com/4.bp.blogspot.com/-qiVkXksBF9c/TcHPfQ7edXI/AAAAAAAAAEc/axHlf9resQ4/s320/MPC_breadboard.JPG?resize=320%2C245" width="320"  data-recalc-dims="1" /></a>
    </td>
  </tr>
  
  <tr>
    <td>
      The Finished Breadboard
    </td>
  </tr>
</table>

**<span>TV & Amp Remotes</span>**

Anyway, it turns out that the amp was easy.  Its power button uses the NEC protocol, command code is 0x10ef08f7.  Very simple to send that out again through the IR LED.

<pre></pre>

A great trick that can be done with any digital camera.  Point an infrared remote at it and hit the button.  Digital cameras can see infrared, so this is a good way to see if your transmitter is actually working.  Of course, you can't see the signal pulses, but you can see the IR LED light up.

The TV on the other hand was not as easy.  It's a Panasonic, and IRremote doesn't understand the protocol.  Fortunately, we can fall back to raw mode.  Grabbing the raw output from IRdemo, in order to massage the figures into something that's appropriate to send back out again, you need to chop the first entry off (which is just a gap), and then remove all the signs from all the entries (negative is a space).  That gives me this;

> <span>// Sends a power-on signal to the Panasonic TV<br />void powerTV()<br />{<br />     // Panasonic TV, output is raw (unfortunately)<br />     // Much of this is probably repeated, but so what.<br />     const unsigned int rawCodes[] = {<br />         3550,1750,400,450,450,1300,450,450,400,450,450,450,400,450,450,450,400,450,450,450,400,450,400,500,400,450,400,500,400,1300,450,450,400,450,450,450,400,450,400,500,400,450,400,500,400,450,400,500,400,1300,450,450,400,450,450,450,400,450,450,450,400,450,400,500,400,450,400,1350,400,500,400,1300,450,1300,450,1300,400,1350,400,500,400,450,400,1350,400,450,450,1300,450,1300,450,1300,400,1350,400,500,400,1300,450<br />     };<br />     irsend.sendRaw((unsigned int *)rawCodes, sizeof(rawCodes)/sizeof(int), 38);<br />}</span>

The odd entries are the marks (where the LED is on), and the even entries are the spaces (where the LED is off).  It's very likely that code has spurious stuff in it that's not required, but sending that signal out makes the TV turn on and off, so I don't care.  You define the array as a const because it's not being changed and therefore you want it in code space (32k) and not RAM.  The [Atmega328p](http://www.atmel.com/dyn/products/product_card.asp?part_id=4198) used in the Arduino Uno only has 2kb of RAM, and some of that is blown by libraries and other stuff.

Next up is the Media Center Remote.  I needed to actually decode the protocol for that, since I'd definitely run out of memory on the Atmega if I didn't, and besides, it's cooler.

**<span>Media Center Remote Protocol</span>**

The code for the IR Blaster can be found at [MPC\_IR\_Blaster.pde](http://code.google.com/p/zencoding-blog/source/browse/trunk/arduino/mpc_irblaster/MPC_IR_Blaster.pde) at my GoogleCode repository.  To make the decoding of the protocol easier, rather than write my own custom handler in the IRremote library, I just leveraged the existing libraries, and then wrote a custom decoder that handled the raw code.

Fuzz factor is required, since when you receive a raw code with IRremote, the figures you get are fudged to be approximate durations of marks and spaces.  So if you're trying to match those to bits, you need a little fuzz factor to help out.  Values received in the raw buffer are in 50us ticks, so a single tick worth of fuzz is enough.

From examining every button on my remote, I noticed that the protocol has six values that it uses, with approximate values of;

  * Mark Long and Space Long - 18 ticks
  * Mark Short and Mark Short - 9 ticks
  * Special Mark Long - 54 ticks
  * Special Mark Short - 27 ticks

The "special marks" always appear in the same place in the received buffer, that is, they're the first mark, and the tenth.  They are always followed by a long space.  In between those two marks are always eight marks and eight spaces, which are always the same.  Following that is a set of 24 marks and 24 spaces which is always the same, followed by another set of up to 32 marks and 32 spaces which are variable.

So, using a quick bit of coding theory, we can assign bits to the marks and spaces, as so;

  * MARK\_SHORT + SPACE\_SHORT = 00
  * MARK\_SHORT + SPACE\_LONG = 01
  * MARK\_LONG + SPACE\_SHORT = 10
  * MARK\_LONG + SPACE\_LONG = 11

So each pair of mark and space gives us two bits.  From there, we can assemble groups of 4 bits into hex digits, and we get the following example packet; 

> Packet Data:  xAAyAAAAAACCCCCCCC
> 
> x = Special long mark/space pair  
> y = Special short mark/space pair  
> A = Static value of 0x05000008, assumed to be the ID of the remote or a special marker  
> C = Command code.  Variable length, assumed any missing least significant bits are zeroes.  The high byte toggles between 0x10 and 0x04 on each keypress, assumed to be for detection between multiple keypresses and holding a key down.

Now, given the above, we can do some pretty basic bit arithmetic and shifting to convert the incoming raw buffer into a single unsigned long command code, which we can easily process and match against.

Don't forget that the marks and spaces are matched against the template values above using the fuzz factor, to account for variance!

**<span>Putting it together</span>**

Reading the code of [MPC\_IR\_Blaster.pde](http://code.google.com/p/zencoding-blog/source/browse/trunk/arduino/mpc_irblaster/MPC_IR_Blaster.pde), you can see how I've done the matching, and what happens.  If we get a valid MCE command code, we match it against any of the coloured button codes, light up the RGB LED as appropriate, wait for SEND_DELAY milliseconds, then transmit (if appropriate).  If we match the code as an MCE code, but don't know what it does, we print the code to the serial port.

Note that DEBUG should be undefined if the Arduino won't be connected to a serial port, otherwise it appears to wait for one, so it won't work off your computer.

Also, in IRremoteInt.h, change the line around line 178 which reads;

> <pre><span>#define TIMER_DISABLE_INTR   (TIMSK2 - 0)</span></pre>

Change it to read;

> <pre><span>#define TIMER_DISABLE_INTR   (TIMSK2 = 0)</span></pre>

So, I assembled the whole thing onto a breadboard and ran it.  After a lot of stuffing about and debugging, it works!

However.  The illumination angle for the IR LED I have is a bit too narrow.  I need to get either a very high powered LED so it can just bounce the IR off the walls, or get one that's much wider angle.

**<span>Improvements</span>**

The drive current of the digital pins of the Atmega isn't very high.  In order to get a really bright LED, you should really use a driving circuit, such as a transistor.

For this, I used a BC548C NPN transistor (I have dozens of them handy) and a 10k resistor.  The output pin of the Arduino goes in series through the 10k resistor to the base of the BC548C.  The emitter of the BC548C goes straight to ground.  The collector of the BC548C goes to the cathode (negative) terminal of the IR LED, and the anode of the IR LED goes in series with a 100 ohm resistor to +5V.

<table align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td>
      <a href="https://i2.wp.com/4.bp.blogspot.com/-aK9jxxLGu-8/TcHNHzeHZ8I/AAAAAAAAAEY/pP5_6W1CiwM/s1600/mpc_prototype1.png" imageanchor="1"><img border="0" height="320" src="https://i2.wp.com/4.bp.blogspot.com/-aK9jxxLGu-8/TcHNHzeHZ8I/AAAAAAAAAEY/pP5_6W1CiwM/s320/mpc_prototype1.png?resize=257%2C320" width="257"  data-recalc-dims="1" /></a>
    </td>
  </tr>
  
  <tr>
    <td>
      Prototype Schematic, including driving circuit
    </td>
  </tr>
</table>

Driving the LED through a transistor should mean you can swap out for a much more powerful LED (say a 300mw model!) without being at risk of blowing up your Arduino.  Note that the BC548c I'm using has a maximum collector current of 200mA, and a maximum base-emitter voltage of 5v, so you'll have to change transistors to drive something really powerful.

**<span>Next Steps</span>**

Now I know the prototype works, the next thing is to wait for my new Atmega328p and associated hardware to arrive, and then set up a basic [Arduino-compatible breadboard](http://www.arduino.cc/en/Main/StandaloneAssembly).  Then I can assemble my prototype onto that, make sure everything still works, and then transfer it all to Veroboard.

I should be able to power it from the +5V on USB from the media center, although if I can scavenge a wall wart from something I'm chucking out, I'll use that instead with a voltage regulator.

Next update on this project will be discussing building the Atmega onto a breadboard.