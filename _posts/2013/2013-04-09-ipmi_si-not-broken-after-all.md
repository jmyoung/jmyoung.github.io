---
id: 4
title: ipmi_si not broken after all!
date: 2013-04-09T07:57:00+09:30
author: James Young
layout: post
guid: http://wordpress/wordpress/?p=4
permalink: /2013/04/ipmi_si-not-broken-after-all/
blogger_blog:
  - coding.zencoffee.org
blogger_author:
  - James Young
blogger_permalink:
  - /2013/04/ipmisi-not-broken-after-all.html
categories:
  - Technical
tags:
  - linux
---
Well, it turned out that ipmi_si.ko was not broken after all in the new CentOS 6.3 kernels!  Red Hat changed the module to be included in the base kernel and not as a module, and therefore the way in which I was specifying parameters for it (through modprobe.conf) no longer worked.

Instead what you do to make it work is to append the following to the kernel options in /boot/grub/grub.conf ;

<pre><span style="color: #666666; font-family: Consolas;">ipmi_si.type=kcs ipmi_si.ports=0xca2</span></pre>

And then all is good!