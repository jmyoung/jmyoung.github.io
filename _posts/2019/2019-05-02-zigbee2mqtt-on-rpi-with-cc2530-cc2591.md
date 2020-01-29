---
id: 1142
title: Zigbee2MQTT on RPI with CC2530/CC2591
date: 2019-05-02T14:41:34+09:30
author: James Young
layout: post
guid: https://blog.zencoffee.org/?p=1142
permalink: /2019/05/zigbee2mqtt-on-rpi-with-cc2530-cc2591/
categories:
  - Technical
tags:
  - docker
  - iot
  - zigbee
---
So, if you've flashed a CC2530/CC2591 from my [previous post](https://blog.zencoffee.org/2019/04/flashing-z-stack-on-a-cc2530cc2591-using-a-wemos-d1-mini/), you now probably want to get it talking to something. Here's how you can do that.

## Assumptions

I will assume you are wanting to do the following;

  * Use a Raspberry Pi 2/3 running Raspbian to act at the bridge between the CC2530/CC2591 and MQTT.
  * You're using Raspbian Stretch.
  * You want to use Zigbee2MQTT to get this thing talking to something like HomeAssistant.
  * You want to use the RPI's built-in UART and directly wire the module to the RPI.
  * You don't care about Bluetooth on the RPI.
  * You already have Docker installed on the RPI.
  * You already have Docker-Compose installed on the RPI.
  * You already have your CC2530/CC2591 flashed with KoenKK's Z-Stack firmware, and it's a recent version.
  * You have a mqtt server somewhere already.

Phew. Now with all that in line, let's get moving.

## Hardware Setup<figure class="wp-block-image">

<img src="https://i0.wp.com/blog.zencoffee.org/wp-content/uploads/2019/05/cc2591_pinout.jpg?w=840&#038;ssl=1" alt="" class="wp-image-1143" srcset="https://i0.wp.com/blog.zencoffee.org/wp-content/uploads/2019/05/cc2591_pinout.jpg?w=679&ssl=1 679w, https://i0.wp.com/blog.zencoffee.org/wp-content/uploads/2019/05/cc2591_pinout.jpg?resize=300%2C264&ssl=1 300w" sizes="(max-width: 709px) 85vw, (max-width: 909px) 67vw, (max-width: 984px) 61vw, (max-width: 1362px) 45vw, 600px" data-recalc-dims="1" /> <figcaption>CC2530/CC2591 Pinout Diagram</figcaption></figure> <figure class="wp-block-image"><img src="https://i1.wp.com/blog.zencoffee.org/wp-content/uploads/2019/05/rp2_pinout.png?w=840&#038;ssl=1" alt="" class="wp-image-1144" srcset="https://i1.wp.com/blog.zencoffee.org/wp-content/uploads/2019/05/rp2_pinout.png?w=1006&ssl=1 1006w, https://i1.wp.com/blog.zencoffee.org/wp-content/uploads/2019/05/rp2_pinout.png?resize=300%2C179&ssl=1 300w, https://i1.wp.com/blog.zencoffee.org/wp-content/uploads/2019/05/rp2_pinout.png?resize=768%2C458&ssl=1 768w" sizes="(max-width: 709px) 85vw, (max-width: 909px) 67vw, (max-width: 1362px) 62vw, 840px" data-recalc-dims="1" /><figcaption>RPI2/3 GPIO Pinout</figcaption></figure> 

Using the two charts above, you will need to make the following connections;

<table class="wp-block-table aligncenter">
  <tr>
    <td>
      PIN PURPOSE
    </td>
    
    <td>
      <strong>CC2591</strong>
    </td>
    
    <td>
      <strong>RPI PIN</strong>
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
</table>

This is the minimum set of pins required. Note that RXD on the CC2591 gets connected to TXD on the RPI. This is normal.

**Do not connect the CC2530 to the 5V lines on the RPI. Doing so will likely destroy the CC2530.**

## Configure UART on the RPI

What we'll be doing is using the UART on the RPI. There are a number of ways to do this, but we'll use the method which disables Bluetooth and puts the UART on the high-performance device /dev/ttyAMA0.

Edit your /boot/config.txt and add the following;

<pre class="wp-block-preformatted">dtoverlay=pi3-disable-bt</pre>

Then edit /boot/cmdline.txt and remove the following bit from the only line;

<pre class="wp-block-preformatted">console=serial0,115200</pre>

Reboot your Pi, and you should now have the UART pins listed above manifest on /dev/ttyAMA0. Don't try and use minicom or similar to connect to it, you won't see much useful.

## Set up a HomeAssistant Docker-Compose File

We're going to use Docker Compose to run [zigbee2mqtt](https://www.zigbee2mqtt.io/) in a container. Make a directory somewhere for it, and a data directory, like so;

<pre class="wp-block-preformatted">mkdir -p /srv/zigbee2mqtt/data</pre>

Then edit /srv/zigbee2mqtt/docker-compose.yml, and fill it in like this;

<pre class="wp-block-preformatted">version: '2'<br /> services:<br />   zigbee2mqtt:<br />     image: koenkk/zigbee2mqtt:arm32v6<br />     restart: always<br />     volumes:<br />       - /srv/zigbee2mqtt/data:/app/data<br />     devices:<br />       - /dev/ttyAMA0:/dev/ttyAMA0</pre>

Now, this will spin up a zigbee2mqtt service when you start it, which will always restart when stopped, using /dev/ttyAMA0 as we defined earlier. Lastly, create a /srv/zigbee2mqtt/data/configuration.yaml and fill it in like this;

<pre class="wp-block-preformatted">homeassistant: true<br />permit_join: true<br />mqtt:<br />  base_topic: zigbee2mqtt<br />  server: 'mqtt://YOURMQTTSERVERHERE:1883'<br />  include_device_information: true<br />serial:<br />  port: /dev/ttyAMA0<br />advanced:<br />  log_level: info<br />  baudrate: 115200<br />  rtscts: false<br /></pre>

I strongly suggest you change the network key, and disable permit_join when you have all your devices up. There's various other things to do here too, but this should get you started.

Once that's done, a simple;

<pre class="wp-block-preformatted">docker-compose up</pre>

Should bring up your container. Press Ctrl-\ to break out without terminating it.