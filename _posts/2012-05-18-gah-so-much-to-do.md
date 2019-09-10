---
id: 41
title: Gah! So much to do!
date: 2012-05-18T03:02:00+09:30
author: James Young
layout: post
guid: http://wordpress/wordpress/?p=41
permalink: /2012/05/gah-so-much-to-do/
blogger_blog:
  - coding.zencoffee.org
blogger_author:
  - James Young
blogger_permalink:
  - /2012/05/gah-so-much-to-do.html
categories:
  - Other
---
Wow, it's been an eventful week - lots of projects are now coming to the point where I can actually DO stuff with them, so now it's a matter of prioritization.  Of course, Diablo 3 was released this week which threw an additional spanner in the works.

**Flight Sims** - I've been teaching myself to fly in XPlane, using the Saitek X52 Pro throttle, stick, and rudder set I bought.  Mostly I've been flying the Cessna 172SP.  Going fairly well, but I've been distracted off it by Diablo 3.  I also went and grabbed DCS A-10C Warthog off Steam, though I'm still to actually try it.  I also already have DCS Black Shark, and I have to admit it's a hell of a lot easier to fly the Ka-50 with proper controls.  I'm trying to resist turning anything over to Game mode and running on full Simulation mode.  I've also turned off all the navigation helpers in XPlane, so I have to use proper navigation techniques (triangulation from NDBs/VORs and such).  It's complex, but fun.

**Diablo 3** - The gorilla in the room for gaming this week.  I'm playing this a fair bit at the moment, but this weekend it'll have to go on the backburner.  Levelling up a Wizard, and I'm playing with my wife's Demon Hunter when we get time.  I'm seriously considering changing to Monk, but I reckon I'll stick with Wizard for now.  Currently D3 has pushed my other gaming endeavours off to the side, of which there are quite a few.

**AeroQuad Frame** - I stripped my existing quad to flash the Turnigy Plush 25A ESCs with SimonK firmware.  Since I had to strip the quad entirely to do this, I thought I'd take the opportunity and completely rebuild the frame, along with enlarging the FCU container so I could fit in an AQ Mega board.  New frame design is similar, but has a few optimizations and enhancements - namely the motor mounts are integrated into the arms, vibration isolation is handled via grommets on a plate, the FCU is bolted directly to a plate with nylon standoffs (thus making it straight and level), and the design is more modular so that the arm assembly can be removed separately from the ESC/FCU assembly.  Still made of aluminium.  Pictures and such to follow when I finish cutting the new landing gear.

**AeroQuad Board** - I also just received my customized AeroQuad 2.0.7a PCBs today!  Timing's good, since I haven't completed assembly of the AQ frame, so I can swap in the new board (once I transfer sensors) and start the new frame with an AQ Mega board.  It also means I'll have to come up with a sonar mount design for the new frame.  That shouldn't be hard (just an aluminium strap between the two front arms should do the trick).  I customized the AQ 2.0.7 board because I wanted to use that version (and not 2.1) because I already have most of the sensors on my AQ 1.9 board.  In addition, I wanted to use a HMC5883L magnetometer, which requires some board modifications and since I was getting a board made by BatchPCB since the AQ store was out of stock anyway, I modified the design slightly to let me put on the magnetometer on the top of the board.  Pictures and blog post when I assemble it.

**BusPirate Breakout** - When I ordered my custom AQ board from BatchPCB, I also threw in a run of Schapp's BP breakout board, a tiny little board which plugs into the top of a Bus Pirate and breaks out into a bunch of common connectors.  The most relevant for my interest in an SPI/ISP 6-pin port, just perfect for using to program AVRs.  Getting that board with the other one only cost me $2.50.  The funny thing is that I only ordered one, but I wound out getting six in the package (I also got two of my AQ 2.0.7a boards!).  I guess the panel must have had some spare space.  Cheers BatchPCB!

**ArduCopter Frame** - I received my new 3DRobotics 3DR-B frame along with my new [ArduPilotMega 2.0](http://store.diydrones.com/APM_2_0_Kit_p/br-ardupilotmega-03.htm) board.  However, I've decided to sell the 3DR-B frame since I want a frame that is more different than my current homemade frame, and I want something that's better for FPV purposes, since that's what I want the APM for.  Something like this (which has now been ordered) - the [HoverThings HT-FPV](http://www.hoverthings.com/htfpvblack.html).

**ArduPilotMega 2.0** - I also got my new APM2 control board.  However, this is going to go on the backburner for a while.  I've got the motors, props, and ESCs for the thing, but I need the new frame which I ordered, and I want to get my existing AQ all set back up again.  I got the APM2 because I wanted a controller which had GPS and more programmability than you can (currently!) get with AQ, and I want to eventually use the thing for FPV.

**Lasers and Motor Balancing** - I saw a great idea for balancing motors.  Put the motor on a thin bit of wood with a mirror glued to it, then bounce a laser off the mirror and use the deflection of the laser to check if the motor is vibrating and by how much.  I've always neglected balancing my motors, but I figure I should start, since vibration is the enemy of quads.  I went out and ordered in a 1mW green laser ($12 delivered!), and by oath the thing is bright for 1mW.  It turns out in SA it's extremely difficult to buy any kind of laser 'pointer' from a normal shop, even a low power model.  eBay to the rescue!  I didn't want anything _powerful_ since it's only for balancing motors, but I decided to go with green since it's a lot brighter than red for the same power output.  And is this thing ever bright!  Keep away from the eyes...

So, so many things on the list to do!  I'll post up more as I get each thing done.  Tonight I intend on starting to make the laser rig, then tomorrow I'll finish off the landing gear for the new quad frame.  Over the weekend I hope to start disassembling the old AQ board and assembling the new one, and if I don't run out of time I might have the old quad fully assembled and ready to test by Sunday.