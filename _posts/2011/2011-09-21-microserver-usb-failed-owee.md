---
id: 64
title: 'Microserver &#8211; USB Failed (owee!)'
date: 2011-09-21T05:03:00+09:30
author: James Young
layout: post
guid: http://wordpress/wordpress/?p=64
permalink: /2011/09/microserver-usb-failed-owee/
blogger_blog:
  - coding.zencoffee.org
blogger_author:
  - DW
blogger_permalink:
  - /2011/09/microserver-usb-failed-owee.html
categories:
  - Technical
---
Well, it only took three months, but the USB key I was driving my Microserver from went bang over the weekend.  It started accumulating a lot of errors, and fsck fixed the errors, but they just came back again.  Doing some analysis, I don't believe that I was committing too many writes to the key - I only would have made under 1Gb worth of writes, and with a 16Gb USB key, there's no way I should have committed enough writes to be able to blow the read/write cycle limit of even one block on the key.

Given that the key was a very small key, I'm inclined to believe that it didn't have a proper wear level controller on it.  In counterexample, I have another box that's been happily running on a compactflash card (underlying technology is still flash) for over two years without issues.

Anyway, it was all rather painful.

So I've reconstructed my Microserver, set up some cron jobs to back it up to spinning rust disks once a day, and I've also set up some jobs and other such so that MRTG writes its data to a tmpfs ramdisk, and then once every two hours that data gets zipped up and dumped onto the USB key.  That way I have a single ~250k set of writes once every two hours instead of ~650k every five minutes.  We'll see how it goes.

I've also been given the idea from a work colleague of using rsync to make hardlinked backups of my USB key to rust.  I'll experiment with that later and report results.

On the Arduinoven front, I've gotten the PID controller working acceptably - I had to use a temperature averaging algorithm to filter out noise.  I haven't touched the code in a week or two, but I'll keep working on it when I have time.  The hardware itself has worked perfectly, which I'm pretty happy about.