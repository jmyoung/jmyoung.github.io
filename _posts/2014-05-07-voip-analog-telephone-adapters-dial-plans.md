---
id: 732
title: 'VOIP Analog Telephone Adapters &#8211; Dial Plans'
date: 2014-05-07T16:44:03+09:30
author: James Young
layout: post
guid: http://blog.zencoffee.org/?p=732
permalink: /2014/05/voip-analog-telephone-adapters-dial-plans/
categories:
  - Other
tags:
  - voip
---
Picked myself up a [Cisco SPA112](http://www.cisco.com/c/en/us/products/unified-communications/spa112-2-port-phone-adapter/index.html) to replace the wonky built-in VOIP capability of my router.  However, I seem to have some unusual behaviour.  Namely, when I take my cordless phone off the hook, I only get about 4 seconds to start entering numbers before the ATA switches over to the "off hook alarm" mode and rejects any further digits.  Unfortunately, the phone's built-in dialer waits a few seconds before starting to dial, so it's pretty random whether you can dial or not.

It turns out the problem here was the dial plan!  There's a few timeouts in play here - the off-hook timer (5 seconds), the interdigit long delay (10 seconds) and the interdigit short delay (3 seconds).  My dial plan was causing the interdigit short delay to start counting as soon as the phone was taken off the hook!  Here's what I used;

<pre>(000|106|0[23478]xxxxxxxx|[2-9]xxxxxxx|*xx|111|*9xx|13[1-9]xxx|1[389]00xxxxxx|001xxx.|x.)</pre>

What causes the issue here is the "x." plan.  That translates to "any digit, zero or more times".  This means as soon as the phone is taken off of the hook, the interdigit short delay is triggered because the entered digits (none) match at least one rule in the dial plan.

The solution here is to use a (much) better dial plan, namely;

<pre>(000S0|106S0|183[12]x.|1[389]xxxxxxxxS0|13[1-9]xxxS0|0[23478]xxxxxxxxS0|[2-9]xxxxxxxS0|001xxxx.S5|111S0|*xx.)</pre>

This plan is fairly complicated, so I'll break it down piece by piece.  Notably, this plan won't allow arbitrary number dialing like the first one does, all numbers have to match something in the plan somewhere.

  * **000S0**, **106S0**, **111S0** - Immediately dial these numbers (emergency numbers) as soon as they are entered without waiting for further digits (S0 sets the interdigit short delay to zero)
  * **183[12]x.** - Dial any number which starts with 1831 or 1832, after waiting until no digits have been entered until the interdigit short delay timer (3 seconds) expires.  Note that the period means "match the preceding token zero or more times".
  * **1[389]xxxxxxxxS0** - Immediately dial a 13, 18, or 19 number once ten entered digits have been reached
  * **13[1-9]xxxxS0** - Immediately dial a 13 number once six digits have been reached.  Note that this would conflict with the rule above it, except all ten-digit 13 numbers are 130 numbers meaning they don't match this rule.
  * **0[23478]xxxxxxxxS0** - Immediately dial a standard Australian STD number including area code (two digit area code starting with 0, eight digit number)
  * **[2-9]xxxxxxxS0** - Immediately dial a standard Australian local number with no area code (eight digits)
  * **01xxxx.S5** - Dial an International number of five or more digits, resetting the interdigit short delay to 5 seconds for this dial (to give more time to dial numbers)
  * ***xx.** - Dial a star-code of one or more digits after waiting for the interdigit short delay to expire (3 seconds)

The immediate dials reduce time delay for the dialer (ie, waiting 3 seconds after dialing for something to happen), but they can also conflict if two rules match a possible number.

For example, if you tried to dial 1301234567 with that plan (which is a theoretically valid ten-digit 13 number), you'll find that you will actually dial 130123 and the rest of your digits will be discarded.  This isn't a problem here because 130 is never used for ten-digit 13 numbers.

You can do an awful lot with dial plan codes, as well as bust things in weird ways.