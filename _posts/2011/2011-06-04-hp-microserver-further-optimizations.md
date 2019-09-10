---
id: 82
title: 'HP Microserver &#8211; Further Optimizations'
date: 2011-06-04T02:09:00+09:30
author: James Young
layout: post
guid: http://wordpress/wordpress/?p=82
permalink: /2011/06/hp-microserver-further-optimizations/
blogger_blog:
  - coding.zencoffee.org
blogger_author:
  - DW
blogger_permalink:
  - /2011/06/hp-microserver-further-optimizations.html
categories:
  - Technical
tags:
  - linux
---
Did some more optimizations on my Microserver to improve performance and reduce the write I/O going to the USB flash. 

First thing was fixing up the script I used to set the noop scheduler on the USB key.  I didn't like using sdc directly since that will change.  Instead, I now do this;

> <span>find /sys/devices/pci0000:00/0000:00:13.2/usb* -name "scheduler" -exec sh -c "echo noop > {}" \;</span>

<div>
  This finds all USB devices plugged into that PCI device (ie, all of them), and sets their scheduler to noop.  This has the desired effect without touching the hard disks.
</div>

<div>
</div>

<div>
  Secondly, I added the following line to <span>/etc/fstab</span> ;
</div>

<div>
  <blockquote>
    <p>
      <span>tmpfs   /tmp    tmpfs   defaults  0       0</span>
    </p>
  </blockquote>
</div>

<div>
  This causes the /tmp directory to be mounted as a temporary filesystem in RAM, reducing writes to the USB by quite a lot.  Since I have 8Gb of RAM, there isn't much penalty here (if any).  The good thing about tmpfs is that it only consumes memory for files that are actually written.  It's better to use <span>noexec,nosuid</span> if you can, but I found that if I used that then scripts that are called as part of <span>apt-get</span> couldn't run.  And at any rate, the default /tmp doesn't have those bits enabled.
</div>

<div>
  Next up is to look at how much logging is going on and reducing it.
</div>