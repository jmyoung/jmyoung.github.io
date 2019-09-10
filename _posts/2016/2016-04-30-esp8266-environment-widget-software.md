---
id: 891
title: 'ESP8266 Environment Widget &#8211; Software'
date: 2016-04-30T20:51:16+09:30
author: James Young
layout: post
guid: https://blog.zencoffee.org/?p=891
permalink: /2016/04/esp8266-environment-widget-software/
categories:
  - Electronics
tags:
  - esp8266
---
Last post I mentioned how I got an [ESP8266](https://www.sparkfun.com/products/13678) board.  Well, I've put together that with a [DHT11](https://www.adafruit.com/product/386) and [MQTT](http://mqtt.org/) to create a widget that senses temperature and humidity, then posts that on a regular basis to your MQTT message broker.  The data comes out in JSON format for ease of use.  I'll cover the hardware later, once I get the rest of my prototype boards.

## Preparing your ESP8266

Following guides mentioned in my previous post, wire up your ESP8266.  Then, connect your DHT such that the output pin is going to GPIO2 on the ESP8266.

Go and install [NodeMCU](https://github.com/nodemcu/nodemcu-firmware).  Remember to ground GPIO0 if you are going to upload firmware!  You can use either the float or integer version (I used the float version).  The DHT11 only produces integer temperature and humidity stats anyway, so it doesn't make any difference.

Next, go to my [Github repository](https://github.com/jmyoung/zencoding-blog/tree/master/esp8266/dht_reader) and grab the two LUA files.  Don't upload them to the ESP yet!  Just put them somewhere.

If you have installed NodeMCU, you can now stop grounding GPIO0.  Technically you should pull that high with a pullup, but I haven't bothered yet.  I'll do that in the final hardware.

Lastly, fire up [LuaLoader](http://benlo.com/esp8266/) and configure your wifi.  This is persistent, as long as you don't reflash the NodeMCU firmware.

## The init script

If you put immediately-executing code into init.lua, you run into a problem - you can't break out into the interactive shell anymore, and therefore you have to reflash in order to get back.  Not optimal.

The way around that is to have init.lua wait a short time and then execute a _different_ script.  You then have time to either manually abort the alarm timer, or get rid of init.lua and reboot.

Here's a code fragment that does that;

<pre>function startup()
	print('executing script')
	dofile('dht_reader.lua')
end

print("in startup, 'tmr.unregister(0)' to abort")
tmr.alarm(0,10000,0,startup)</pre>

Pretty simple.  You get 10 seconds to abort before the main script executes.

## The reader script

I'm not going to go through the [reader script](https://raw.githubusercontent.com/jmyoung/zencoding-blog/master/esp8266/dht_reader/dht_reader.lua) line-by-line, but I will mention some bits about how it works.  First up, NodeMCU is heavily callback driven.  You're intended to use an event-based paradigm with it, leading to some strange-looking code.  Also, my Lua is pretty limited, I mostly just bumbled my way through it.

Anyway, configuration is with the variables at the top.  dht\_gpio = 4 corresponds to GPIO2.  Set your mqtt details appropriately, including the client ID you want this widget to use.  Leave mqtt\_ip and mqtt_client nil, they're used internally.

The actual code execution is event driven by callbacks.  Everything is triggered off by attempting to do DNS resolution for your MQTT server.  NodeMCU includes a nice watchdog timer, and the watchdog is used extensively.  It's armed at the beginning, and gets reset only when an MQTT message is successfully published.  If anything happens so that an MQTT message won't be published, something bad happened and the device will eventually reset.

That should cover all possibilities of wifi going away, mqtt broker dying, no IP address etc etc.

It's notable that NodeMCU on my ESP8266 does not have the [sntp](https://nodemcu.readthedocs.io/en/dev/en/modules/sntp/) module.  This means it has no idea what the real time is, not even close.  As such, I don't address that.  The 'raw' JSON that's published is intended to be cooked by another script which will add an expiry time.  More on that later.

After unwrapping all the callbacks, our control flow looks like this;

  1. Arm the watchdog timer.  If it goes off, we reboot.
  2. DNS resolve MQTT broker.  If we got an IP... 
      1. Connect to the MQTT broker.  If we connected... 
          1. Start a repeating alarm every minute.  When that alarm goes off... 
              1. Get the DHT sensor details.  If that worked... 
                  1. Publish that to MQTT and reset the watchdog
  3. Twiddle thumbs

It's a little more complicated than that (ie, it tries to reconnect to the broker if it disconnects), but not much.

It should be fairly straightforward to wrangle that to support more complex devices such as stuff on an I2C bus.

Enjoy!