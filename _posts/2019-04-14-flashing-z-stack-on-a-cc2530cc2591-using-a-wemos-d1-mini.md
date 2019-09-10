---
id: 1123
title: Flashing Z-Stack on a CC2530+CC2591 using a Wemos D1 mini
date: 2019-04-14T20:13:40+09:30
author: James Young
layout: post
guid: https://blog.zencoffee.org/?p=1123
permalink: /2019/04/flashing-z-stack-on-a-cc2530cc2591-using-a-wemos-d1-mini/
categories:
  - Radio
  - Technical
tags:
  - iot
  - wemos
  - zigbee
---
I'm messing about with Zigbee for a comms protocol to various temperature sensors, and this requires a [Zigbee Coordinator](https://www.digi.com/resources/documentation/Digidocs/90002002/Content/Concepts/c_zb_coord_op.htm). There's a few ways of doing this, but ultimately I settled on a [zigbee2mqtt](https://www.zigbee2mqtt.io) bridge and a cheapie AliExpress CC2530+CC2591 module.

This module incorporates an RF amplifier, but does not have the normal debug header that the CC2530 Zigbee transceivers have and also lacks the USB-TTL adapter chip. Not a problem if you're using a RPi as the bridge, which is what I plan on doing.

However first, you need to get [Z-Stack firmware](https://github.com/Koenkk/Z-Stack-firmware/tree/master/coordinator/default/CC2530_CC2591) on it, so you can use it as a coordinator. This proves to be... non-trivial. Especially if you want to use a [Wemos D1 Mini](https://wiki.wemos.cc/products:d1:d1_mini) as the flashing device (these Wemos things are really good, incidentally).

## First Steps - Getting CClib-Proxy onto the Wemos

Assuming you have a Wemos D1 mini, your first steps are to install the Arduino IDE (available from the Windows Store). Once that's in, in Preferences, add the following URL to the Additional Boards Manager URL field;

[http://arduino.esp8266.com/stable/package\_esp8266com\_index.json](http://arduino.esp8266.com/stable/package_esp8266com_index.json)

From there, you should now be able to go to the Boards Manager, and install the esp8266 package. Once that is installed, configure your board as a "LOLIN(WEMOS) D1 R2 & Mini" and select the correct COM port.

Now it's as simple as downloading CCLib-Proxy from [this link](https://github.com/kirovilya/CCLib). Open up CCLib_Proxy.ino, then change the following lines for the pinout;

<pre class="wp-block-preformatted">int CC_RST   = 5;<br /> int CC_DC    = 4;<br /> int CC_DD_I  = 14;<br /> int CC_DD_O  = 12;</pre>

These mappings are required. Upload to your device. You now have CClib-Proxy onto the Wemos and ready to go.

## Wiring up the Wemos to the CC2530+CC2591 Module

You will need to map various pins on the Wemos to pins on the module, using the following chart;

<table class="wp-block-table">
  <tr>
    <td>
      <strong>PIN PURPOSE</strong>
    </td>
    
    <td>
      <strong>NUMBER ON CC2591</strong>
    </td>
    
    <td>
      <strong>NUMBER ON WEMOS</strong>
    </td>
  </tr>
  
  <tr>
    <td>
      DC (Debug Clock)
    </td>
    
    <td>
      P2_2
    </td>
    
    <td>
      D2 (GPIO4)
    </td>
  </tr>
  
  <tr>
    <td>
      DD (Debug Data)
    </td>
    
    <td>
      P2_1
    </td>
    
    <td>
      D5 (GPIO14)<br />D6 (GPIO12)
    </td>
  </tr>
  
  <tr>
    <td>
      RST (Reset)
    </td>
    
    <td>
      RST
    </td>
    
    <td>
      D1 (GPIO5)
    </td>
  </tr>
  
  <tr>
    <td>
      VCC (Supply)
    </td>
    
    <td>
      VCC
    </td>
    
    <td>
      3V3
    </td>
  </tr>
  
  <tr>
    <td>
      GND (Ground)
    </td>
    
    <td>
      GND
    </td>
    
    <td>
      G
    </td>
  </tr>
  
  <tr>
    <td>
      RXD (Receive Data)
    </td>
    
    <td>
      P0_2
    </td>
    
    <td>
      RPI Pin 8 (TXD)
    </td>
  </tr>
  
  <tr>
    <td>
      TXD (Transmit Data)
    </td>
    
    <td>
      P0_3
    </td>
    
    <td>
      RPI Pin 10 (RXD)
    </td>
  </tr>
  
  <tr>
    <td>
      CTS (Clear To Send)
    </td>
    
    <td>
      P0_5
    </td>
    
    <td>
      RPI Pin 11 (RTS)
    </td>
  </tr>
  
  <tr>
    <td>
      RTS ( Ready To Send)
    </td>
    
    <td>
      P0_4
    </td>
    
    <td>
      RPI Pin 36 (CTS)
    </td>
  </tr>
</table>

When using a Wemos as the flashing device, it's safe to tie the two I/O pins together (D5 and D6) and connect them to the DD pin on the CC2530. It works fine. The P0\_2 through P0\_5 pins are used when you're using the finished device, not when flashing (so you don't need to connect them up).<figure class="wp-block-image">

<img src="https://i0.wp.com/sc01.alicdn.com/kf/HTB1E_k1FFXXXXawXXXXq6xXFXXXP/220671527/HTB1E_k1FFXXXXawXXXXq6xXFXXXP.jpg?w=840&#038;ssl=1" alt="" data-recalc-dims="1" /> <figcaption>Pinout for CC2530+CC2591 module  
</figcaption></figure> 

The above diagram shows the pin mappings on the CC2530+CC2591 module itself. Follow those numbers and the pins above to wire it up.<figure class="wp-block-image">

<img src="https://i1.wp.com/ptvo.info/wp-content/uploads/2018/06/smartrf04eb-pinout.png?w=840" alt="" data-recalc-dims="1" /> <figcaption>Pinout of Debug Header on CC2530 (not present on combined module)</figcaption></figure> 

This diagram shows the pinout of the debug header (which is not present on the CC2591). However, it does show which pins on the CC2591 marry up to what purposes on the debug header (which correspond to pins on the Wemos).

After this is done, you need to use CClib to flash the firmware. 

## Flashing the Z-Stack Firmware

Get the firmware from [this link](https://github.com/dzungpv/Z-Stack-firmware/tree/master/coordinator/CC2530_CC2591). You will also need to install [Python 2.7](https://www.python.org/download/releases/2.7/) for your system. Once that's done, install pyserial with;

<pre class="wp-block-preformatted">pip install pyserial==3.0.1</pre>

Edit the firmware .hex you downloaded, and remove the second to last line (it won't work with the flasher you're using). Once that is done, connect your Wemos to your computer, and then from the Python directory in your CClib download, run;

<pre class="wp-block-preformatted">python cc_info.py -p COM9</pre>

Assuming that COM9 is your Wemos. You should see output giving you data on the CC2530. If so, fantastic. Now flash it;

<pre class="wp-block-preformatted">python cc_write_flash.py -e -p COM9 --in=YOURFIRMWAREHERE.hex</pre>

This will take an extremely long time. Several hours. But you should see progress fairly quickly. Just hang tight. Once that's done, you have a coordinator!

Next post will deal with testing the coordinator out.

## References and Links

  * [Wemos D1 Mini with Arduino IDE Guide](https://www.instructables.com/id/Wemos-ESP8266-Getting-Started-Guide-Wemos-101/)
  * [Wemos D1 Mini Pinout and GPIO Chart](https://wiki.wemos.cc/products:d1:d1_mini#pin)
  * [zigbee2mqtt flashing documentation](https://www.zigbee2mqtt.io/information/alternative_flashing_methods.html)
  * [Z-Stack Firmware for CC2530+CC2591 (Standard)](https://github.com/Koenkk/Z-Stack-firmware/tree/master/coordinator/default/CC2530_CC2591)
  * [Flow Control discussion about CC2530 (Forum Post)](https://github.com/Koenkk/zigbee2mqtt/issues/293)
  * [Z-Stack Firmware with RTCCTS disabled (for my module)](https://github.com/dzungpv/Z-Stack-firmware/tree/master/coordinator/CC2530_CC2591)
  * [Pinout for CC2530+CC2591 Module](https://sc01.alicdn.com/kf/HTB1E_k1FFXXXXawXXXXq6xXFXXXP/220671527/HTB1E_k1FFXXXXawXXXXq6xXFXXXP.jpg)
  * [TTL Pins for Module (Forum Post)](https://github.com/Koenkk/zigbee2mqtt/issues/88)
  * [Debugger Port Mappings](http://ptvo.info/how-to-select-and-flash-cc2530-144/)
  * [Pinouts and Assignments (Forum Post)](https://github.com/ioBroker/ioBroker.zigbee/issues/21)
  * [CCLib Wiring Diagram (for Arduino)](https://raw.githubusercontent.com/kirovilya/CCLib/master/Schematic/arduino-wiring.png)
  * [CCLib-Proxy fork for Arduino](https://github.com/kirovilya/CCLib)