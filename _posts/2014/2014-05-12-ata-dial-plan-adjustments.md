---
id: 740
title: ATA Dial Plan Adjustments
date: 2014-05-12T14:40:56+09:30
author: James Young
layout: post
guid: http://blog.zencoffee.org/?p=740
permalink: /2014/05/ata-dial-plan-adjustments/
categories:
  - Other
tags:
  - voip
---
As discussed in the last post, I adjusted my dial plan to the following;

<pre>(000S0|106S0|183[12]x.|1[389]xxxxxxxxS0|13[1-9]xxxS0|0[23478]xxxxxxxxS0|[2-9]xxxxxxxS0|001xxxx.S5|111S0|*xx.)</pre>

This dial plan gives me immediate dialing for known phone numbers, and appears to work pretty nicely.  However...  My VOIP provider delivers caller ID numbers in internationalized format (but only for national numbers!), so a call from (0412 345 678) comes through to caller ID as 61412345678.

This means that on my cordless phone, I have to add an entry into the phonebook for that number exactly.  And therefore when I go to dial, I'm dialing a number that starts with 6 with no international number prefix (0011).  Therefore, what actually happens is the dial plan component [2-9]xxxxxxxS0 triggers, and dials 61412345, discarding the last three numbers.  Whoops.

What I need is an adjustment to my dial plan so that I can dial eleven-digit stupid numbers that start with 61, having them automatically translated to start with 0, while still allowing me to dial 8-digit numbers that start with 6, WITHOUT introducing an annoying delay in the dial plan.

<pre>(000S0|106S0|183[12]x.|1[389]xxxxxxxxS0|13[1-9]xxxS0|<span style="color: #993300;"><strong>&lt;61:0&gt;[23478]xxxxxxxxS0</strong></span>|0[23478]xxxxxxxxS0|<span style="color: #993300;"><strong>[2-9]xxxxxxxS1</strong></span>|001xxxx.S5|111S0|*xx.)</pre>

The highlighted sections are the relevant pieces.  What happens here is that if you enter an eight digit number starting with 6 (in this example), it will trigger the second highlighted section which gives you one second to type additional digits before dialing.  If you dial additional digits it triggers the first highlighted section.  That section takes a number which starts with 61 and replaces that with 0 and dials.

So, if I dial 61412345 and stop typing, the sequence of events is;

  * Receive eight digits (61412345)
  * Second dial plan is matched, set interdigit short delay to 1 second
  * No more digits received, dial 61412345

And if I dial 61412345678 with no gaps and then stop typing, the sequence is;

  * Receive eight digits (61412345)
  * Second dial plan is matched, set interdigit short delay to 1 second
  * Additional digits received (678), first dial plan is matched
  * Translate leading 61 to a 0, dial 0412345678

And the correct thing happens!  The other way around this would be to change all the S0 matches to S1's (so you have a little time to finish dialing before things happen), and then have a catchall 'xx.' rule at the end to match anything.  That way an 11 digit dial would fall through to the catchall rule and result in a dial.  But doing that would cause the fallthrough rule to only match after 3 seconds, causing a delay whenever you used the phone book.