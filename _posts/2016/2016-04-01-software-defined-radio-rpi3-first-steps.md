---
id: 870
title: 'Software-Defined Radio on RPI3 &#8211; First Steps!'
date: 2016-04-01T13:29:31+09:30
author: James Young
layout: post
guid: http://blog.zencoffee.org/?p=870
permalink: /2016/04/software-defined-radio-rpi3-first-steps/
categories:
  - Radio
  - Technical
tags:
  - linux
  - radio
  - raspberrypi
  - rtlsdr
---
Got myself a [RTL-SDR](http://www.rtl-sdr.com/) Software-Defined Radio (also known as a cheap-as-hell USB DVB-T tuner), and hooked it up to a [Raspberry Pi 3](https://www.raspberrypi.org/products/raspberry-pi-3-model-b/) running [Raspbian](https://www.raspbian.org/).  My objective here was to just get it working, and eventually I'll use it for spectrum analysis and [ADS-B](http://www.airservicesaustralia.com/projects/ads-b/how-ads-b-works/) tracking.

So, I hooked it up, installed [GNU Radio](https://gnuradio.org/redmine/projects/gnuradio/wiki) (by gods this is a complicated toolkit), and shoved on the default terribad antenna and put it in the shed.

The results?  Well, I got something out of it, but by oath it's noisy.  I was expecting that, since I have an awful antenna and no ferrite chokes on anything.  But it works!

<a href="https://i1.wp.com/blog.zencoffee.org/wp-content/uploads/2016/04/sample.jpeg" rel="attachment wp-att-871"><img class="aligncenter size-large wp-image-871" src="https://i1.wp.com/blog.zencoffee.org/wp-content/uploads/2016/04/sample-1024x624.jpeg?resize=660%2C402" alt="Example Waterfall plot" width="660" height="402" srcset="https://i1.wp.com/blog.zencoffee.org/wp-content/uploads/2016/04/sample.jpeg?resize=1024%2C624&ssl=1 1024w, https://i1.wp.com/blog.zencoffee.org/wp-content/uploads/2016/04/sample.jpeg?resize=300%2C183&ssl=1 300w, https://i1.wp.com/blog.zencoffee.org/wp-content/uploads/2016/04/sample.jpeg?resize=768%2C468&ssl=1 768w, https://i1.wp.com/blog.zencoffee.org/wp-content/uploads/2016/04/sample.jpeg?w=1025&ssl=1 1025w" sizes="(max-width: 709px) 85vw, (max-width: 909px) 67vw, (max-width: 984px) 61vw, (max-width: 1362px) 45vw, 600px" data-recalc-dims="1" /></a>

The above is a waterfall plot of a small subsection of the regular FM radio band.  It was created using rtl_power (a standard part of the rtl-sdr kit), and a heatmap generator (available [here](https://github.com/keenerd/rtl-sdr-misc/blob/master/heatmap/heatmap.py)).  The horizontal axis is frequency in MHz, and the vertical axis is time.  Each pixel represents 1kHz of bandwidth and 1s of time.  Brightness indicates received power.

You can clearly see the thick wideband FM transmission at 103.9MHz - that's a commercial radio station.  There's a dull band at 103.7MHz (it sounds like noise when tuning into it), and many smaller bands all across the spectrum, which all sound like buzzes when tuning in.  That's interference.  It's pretty obvious the antenna is terrible.  But the concept works!

That chart was generated like this;

<pre>rtl_power -f 103.5M:104.5M:1k -p 20 -g 35 -i 1s -e 10m sample.csv
python heatmap.py sample.csv sample.jpeg</pre>

Now, you can also record arbitrary things.  Here's a command to record audio to a playable WAV file from the radio station in the above waterfall;

<pre>rtl_fm -f 103.9e6 -M wbfm -s 200000 -r 48000 | sox -t raw -e signed -c 1 -b 16 -r 48000 - recording.wav</pre>

&nbsp;

Now to wait for my new antenna bits to arrive...

&nbsp;