---
id: 88
title: 'ATX Power Supply to Benchtop Supply &#8211; It&#8217;s a Transformer!'
date: 2011-05-24T00:37:00+09:30
author: James Young
layout: post
guid: http://wordpress/wordpress/?p=88
permalink: /2011/05/atx-power-supply-to-benchtop-supply-its-a-transformer/
blogger_blog:
  - coding.zencoffee.org
blogger_author:
  - DW
blogger_permalink:
  - /2011/05/atx-power-supply-to-benchtop-supply-its.html
categories:
  - Electronics
---
**<span>SAFETY WARNING:  Mains voltage (particularly in Australia, where it's 240V) can kill.  This is not a joke.  Improperly handling this equipment could result in severe injuries to yourself or others.  This post is just for information purposes and does not constitute an instruction guide.  I can accept no responsibility for any harm or loss that may be incurred through attempting to do the below.  Please, please, please be careful.</span>**

I realized that in order to be able to supply the 12 volt, 5 amp current required by my Turnigy Accucel-6 LiPo charger, I needed a new power supply.  I've currently got a benchtop power supply (variable) which can put out 12V but with a maximum of 1A.  The other nuisance would be buying an appropriate charger with the right kind of plug.

I've got a spare 320 watt ATX power supply sitting around.  That can put out 10A at 12V and 20A at 5V...  It's switchmode and regulated...  Could I rope that into a cheapo benchtop power supply for 5V/12V?  Turns out I could, and it wasn't too hard.

<a name="more"></a>  
Using the plans I found at [this link](http://www.rccrawler.com/forum/showthread.php?t=163458), I set to work.  I deviated from the plan there, namely with the following points;

  * I didn't connect the -12V and -5V rails.  They only supply up to 0.5A anyway, and it's technically not kosher to run +12V to -12V to yield 24V.  For one, you'd need an isolated ground for your circuit, and if you forgot at any time and connected the "ground" for your device to actual ground, you'd blow your supply up.
  * I cut short one of the +3.3V lines, and the -12V, -5V and standby +5V lines and heatshrunk the ends of them for safety.  This is in case I need to use them later.
  * I heatshrunk _everything_ I put into the case, for safety purposes.  You really don't want one of your wires touching something at line voltage and shorting.  Things would go very badly if it did.
  * I used a panel mount fuse holder on my ground binding post with a 10A fuse attached to it.  While it's not the best place for a fuse (ie, 12V to the case will bypass the fuse) there wasn't actually enough room in the case for two fuse holders, and there's a 15A fuse onboard the supply anyway.  The 10A binding post fuse will help in any circumstance where ground is through the binding post.
  * The power switch I used was major overkill (I think it was a 10A model).  I got that switch because it was really cheap, at half the cost of the smaller switch used in the article.
  * I cut off all the spare GND, +5V and +12V lines at the board, and only soldered on four of each.  Even soldering four onto a single binding post is pretty hard.

When I opened the case (this supply had been left turned off for a year or more), I unscrewed the circuit board and slid it out, being careful not to touch any traces.  I then jumper cabled the big supply capacitors to make sure they were discharged.  You can get a hell of a shock if you touch them while they are charged, so don't do that.  Shifting the board out of the way, I could get to the case to drill the right holes in it.  I wound out using step drills to get the hole sizes I needed.  Be very careful to make sure that no bits of swarf get into the board (put it in a plastic bag if you have to, and thoroughly blow out the case afterwards).  From there, it was a simple matter of following the guide.

Be prepared to be absolutely horrified at the crap soldering job done on the underside of the board.  But apparently it's QC Passed, so I guess that's OK??

After assembly, thoroughly go over your work with a continuity tester.  In particular, you need to make sure that active and neutral on the line in do not have continuity anywhere that should be low voltage (such as the case, your binding posts, the switch, etc).  If they do, make sure you didn't solder bridge anywhere, and make sure there's no chips of metal stuck anywhere.  Don't just think "she'll be right" and power it up anyway.  That's a good way to get a trip to the ER.

All passed for me, so I gave the supply a good shake and tested it again (just in case there was a loose bit of swarf somewhere I missed).  All was fine.  Next test is to power it up with the power switch off (the line voltage will still energize the supply). 

With the supply on at this stage, treat it like an electric fence - fingers off.  I then used my multimeter to check that the case wasn't live (voltage measurement from ground on my shed to the case was 0), and that line voltage wasn't on any of the outputs.  All good.  Turned off the supply at the wall.

Then, I flicked the power switch on, with the supply still off at the wall.  Then with fingers off, turned the wall switch on and checked for safety again.  All good - no line voltage apparent anywhere.  Checked the outputs at 5.2 volts from the 5V line, and 11.96 volts from the 12V line. This is expected, since the 5V line has a load resistor on it, but the 12V line doesn't.  All good.

And finally, gave the supply a good shake and rattle while it was off and listened for anything loose, and then retested it for safety.  All's good.  So I then did the final test, put it down on the bench and turned it on by hand, with one finger.  No shocks.  Great.

So, with that, I've now got a functional 5V/12V 10A supply, and it's in a pretty small case too!  Worth doing, if you're careful.

Pictures later.