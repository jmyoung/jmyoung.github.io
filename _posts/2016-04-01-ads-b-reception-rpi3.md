---
id: 873
title: ADS-B Reception on RPI3
date: 2016-04-01T16:30:11+09:30
author: James Young
layout: post
guid: http://blog.zencoffee.org/?p=873
permalink: /2016/04/ads-b-reception-rpi3/
categories:
  - Radio
  - Technical
tags:
  - radio
  - raspberrypi
  - rtlsdr
---
Well, that was straightforward.  I present you with;

<a href="https://i0.wp.com/blog.zencoffee.org/wp-content/uploads/2016/04/mapview.png" rel="attachment wp-att-874"><img class="aligncenter size-full wp-image-874" src="https://i0.wp.com/blog.zencoffee.org/wp-content/uploads/2016/04/mapview.png?resize=840%2C443" alt="ADS-B Output from dump1090" width="840" height="443" srcset="https://i0.wp.com/blog.zencoffee.org/wp-content/uploads/2016/04/mapview.png?w=915&ssl=1 915w, https://i0.wp.com/blog.zencoffee.org/wp-content/uploads/2016/04/mapview.png?resize=300%2C158&ssl=1 300w, https://i0.wp.com/blog.zencoffee.org/wp-content/uploads/2016/04/mapview.png?resize=768%2C405&ssl=1 768w" sizes="(max-width: 709px) 85vw, (max-width: 909px) 67vw, (max-width: 1362px) 62vw, 840px" data-recalc-dims="1" /></a>

Output collected using the [dump1090](http://www.satsignal.eu/raspberry-pi/dump1090.html) tool.  Setup was pretty straightforward;

<pre>apt-get install librtlsdr-dev git cmake libusb-1.0-0-dev build-essential
git clone git://github.com/MalcolmRobb/dump1090.git
cd dump1090
make</pre>

Once that's done, you have a build of dump1090, which can be used with your SDR to decode [ADS-B](http://www.sprut.de/electronic/pic/projekte/adsb/adsb_en.html) signals from nearby aircraft.  Run this to collect data;

<pre>./dump1090 --interactive --net</pre>

You should start seeing some dumped output for nearby aircraft.  If you see stuff, great!  Pop open your browser, go to http://YOURRPI:8080/ and then drag the map to near where you are.  Aircraft will appear!

I'm pretty surprised with how well I'm picking up aircraft, given how badly placed my antenna is, and how poor the antenna itself is.  Should work even better once I get a decent antenna.