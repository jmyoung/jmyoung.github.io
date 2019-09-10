---
id: 638
title: ATtiny167 Bug with AVR Extended Commands?
date: 2013-07-22T10:23:04+09:30
author: James Young
layout: post
guid: http://blog.zencoffee.org/?p=638
permalink: /2013/07/attiny167-bug-with-avr-extended-commands/
categories:
  - Electronics
tags:
  - avrdude
---
I was advised that there's a bug in my AVRDUDE code for the ATtiny167.  I don't have a 167 to test it for myself as yet, so I'll have to get hold of one, which may take a while.  In the meantime, if you're using a 167 and you get strange errors, attached this to the end of your AVRDUDE command line;

<pre>-x nopagedread</pre>

That extended option will disable my update temporarily.  I'll check it out when I can get hold of one and update patches if required.  This may take some time.

EDIT:  Ouch.  Both Mouser and Digikey want over 30 dollars to ship a $2.50 part.  Postage to Australia really sucks.  If anyone's got one and wants to send it to me, let me know and I'll Paypal you for it.

&nbsp;