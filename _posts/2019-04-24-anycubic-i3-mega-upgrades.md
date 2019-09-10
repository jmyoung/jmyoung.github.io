---
id: 1130
title: AnyCubic i3 Mega Upgrades
date: 2019-04-24T12:11:43+09:30
author: James Young
layout: post
guid: https://blog.zencoffee.org/?p=1130
permalink: /2019/04/anycubic-i3-mega-upgrades/
categories:
  - 3d Printing
tags:
  - 3dprinting
  - anycubic
---
After setting up my printer and doing some test prints and other things, I immediately set forth printing out upgrades for the printer. The intention here is to resolve some deficiencies in the design.

## Filament Guide<figure class="wp-block-image">

<img src="https://i2.wp.com/blog.zencoffee.org/wp-content/uploads/2019/04/ed653b19fd8fcc7a3c9c40f9c1f61aba_preview_featured.jpg?w=840&#038;ssl=1" alt="" class="wp-image-1131" srcset="https://i2.wp.com/blog.zencoffee.org/wp-content/uploads/2019/04/ed653b19fd8fcc7a3c9c40f9c1f61aba_preview_featured.jpg?w=628&ssl=1 628w, https://i2.wp.com/blog.zencoffee.org/wp-content/uploads/2019/04/ed653b19fd8fcc7a3c9c40f9c1f61aba_preview_featured.jpg?resize=300%2C225&ssl=1 300w" sizes="(max-width: 709px) 85vw, (max-width: 909px) 67vw, (max-width: 984px) 61vw, (max-width: 1362px) 45vw, 600px" data-recalc-dims="1" /> <figcaption>Filament Guide</figcaption></figure> 

I printed a filament guide from [Thingiverse](https://www.thingiverse.com/thing:2763266). This needed to be reprinted slightly oversize and trimmed to fit, but it clips around the right-hand side (from the front) allowing filament to go through it and be guided in a straighter line into the filament sensor. A pretty easy print.

## Filament Sensor Guide

Next, the filament sensor default setup is pretty awful. The magnetic ball disconnects all the time, leaving the filament sensor bouncing up and down a lot. So I printed a replacement filament sensor guide from [Thingiverse](https://www.thingiverse.com/thing:2848197).<figure class="wp-block-image">

<img src="https://i2.wp.com/blog.zencoffee.org/wp-content/uploads/2019/04/23e6a29a044f12f02097dc3dff851650_preview_featured.jpg?w=840&#038;ssl=1" alt="" class="wp-image-1132" srcset="https://i2.wp.com/blog.zencoffee.org/wp-content/uploads/2019/04/23e6a29a044f12f02097dc3dff851650_preview_featured.jpg?w=628&ssl=1 628w, https://i2.wp.com/blog.zencoffee.org/wp-content/uploads/2019/04/23e6a29a044f12f02097dc3dff851650_preview_featured.jpg?resize=300%2C225&ssl=1 300w" sizes="(max-width: 709px) 85vw, (max-width: 909px) 67vw, (max-width: 984px) 61vw, (max-width: 1362px) 45vw, 600px" data-recalc-dims="1" /> <figcaption>Filament Sensor Guide</figcaption></figure> 

The design as given has no tolerances built in, so it may be difficult to fit. In particular, I had to trim the flat below the screw hole and widen the hole itself so it would fit. In addition, the far end makes contact with the adjustment screw for the pinch grip on the stepper motor, so I had to cut that off with a knife to make clearance. If I knew more what I was doing with Fusion 360 I'd redesign it to have more clearance, but there you go.

As it is now, it works great - it retains the filament sensor and allows it enough movement to not cause any problems.

## Y-Axis Tensioner

Next is a Y-axis tensioner. I noticed that there was some effects caused by a slightly wobbly belt, so I printed a tensioner mechanism which can adjust the belt tension from [Thingiverse](http://www.thingiverse.com/thing:2789837).<figure class="wp-block-image">

<img src="https://i1.wp.com/blog.zencoffee.org/wp-content/uploads/2019/04/y_axis_tensioner.jpg?fit=840%2C500&ssl=1" alt="" class="wp-image-1133" srcset="https://i1.wp.com/blog.zencoffee.org/wp-content/uploads/2019/04/y_axis_tensioner.jpg?w=3274&ssl=1 3274w, https://i1.wp.com/blog.zencoffee.org/wp-content/uploads/2019/04/y_axis_tensioner.jpg?resize=300%2C179&ssl=1 300w, https://i1.wp.com/blog.zencoffee.org/wp-content/uploads/2019/04/y_axis_tensioner.jpg?resize=768%2C458&ssl=1 768w, https://i1.wp.com/blog.zencoffee.org/wp-content/uploads/2019/04/y_axis_tensioner.jpg?resize=1024%2C610&ssl=1 1024w, https://i1.wp.com/blog.zencoffee.org/wp-content/uploads/2019/04/y_axis_tensioner.jpg?resize=1200%2C715&ssl=1 1200w, https://i1.wp.com/blog.zencoffee.org/wp-content/uploads/2019/04/y_axis_tensioner.jpg?w=1680&ssl=1 1680w, https://i1.wp.com/blog.zencoffee.org/wp-content/uploads/2019/04/y_axis_tensioner.jpg?w=2520&ssl=1 2520w" sizes="(max-width: 709px) 85vw, (max-width: 909px) 67vw, (max-width: 1362px) 62vw, 840px" /> <figcaption>Y-Axis Tensioner  
</figcaption></figure> 

Now there's some notes about this thing. First of all, you MUST have a lock nut on the adjustment screw, otherwise vibration will work it loose and it'll ruin your print. I found out this the hard way. Second, don't tension up the belt too tight, it needs to be tight enough but not enough to bend the stepper pulley. I did it enough that if I push the belt together with my fingers near the middle, I can still get them to touch without undue force.

I had to do a reasonable amount of trimming and fitting to get it to all fit together, sizing holes with a drill bit held in the hand and trimming faces with a craft knife. The assembly order is quite important, so carefully examine how it all works before you try and put it together. Don't overtighten anything, getting too brutal will result in the PLA failing.

I'll likely reprint this in ABS when I get that dialed in.

## Squash Ball Feet

Everything from here required turning the printer on its side and removing the bottom plate. Ghosting is a printing phenomenon where "echoes" of features on a print appear later on the print. It is worsened by higher print speed. Here's an example from Calibration Cube;<figure class="wp-block-image">

<img src="https://i1.wp.com/blog.zencoffee.org/wp-content/uploads/2019/04/ghosting.jpg?w=840&#038;ssl=1" alt="" class="wp-image-1135" srcset="https://i1.wp.com/blog.zencoffee.org/wp-content/uploads/2019/04/ghosting.jpg?w=1006&ssl=1 1006w, https://i1.wp.com/blog.zencoffee.org/wp-content/uploads/2019/04/ghosting.jpg?resize=300%2C291&ssl=1 300w, https://i1.wp.com/blog.zencoffee.org/wp-content/uploads/2019/04/ghosting.jpg?resize=768%2C746&ssl=1 768w" sizes="(max-width: 709px) 85vw, (max-width: 909px) 67vw, (max-width: 1362px) 62vw, 840px" data-recalc-dims="1" /> <figcaption>Ghosting example</figcaption></figure> 

What's happening here is that vibration from the print head changing direction travels through the surface the printer is installed on, then reflects and comes back. When the echo arrives it leaves the ghost you see. So it's interesting because tightly mating the printer to the surface it's on (for example a table) may actually make the ghosting worse, and a larger table provides more time for the echo to travel before it comes back. The solution here is to isolate the printer from the surface that it's on. Enter these feet, printed from [Thingiverse](https://www.thingiverse.com/thing:2764602), with squash balls inserted into them.<figure class="wp-block-image">

<img src="https://i2.wp.com/blog.zencoffee.org/wp-content/uploads/2019/04/135007e7085979a7d5b41ce54c0e54d7_preview_featured.jpg?w=840&#038;ssl=1" alt="" class="wp-image-1136" srcset="https://i2.wp.com/blog.zencoffee.org/wp-content/uploads/2019/04/135007e7085979a7d5b41ce54c0e54d7_preview_featured.jpg?w=628&ssl=1 628w, https://i2.wp.com/blog.zencoffee.org/wp-content/uploads/2019/04/135007e7085979a7d5b41ce54c0e54d7_preview_featured.jpg?resize=300%2C225&ssl=1 300w" sizes="(max-width: 709px) 85vw, (max-width: 909px) 67vw, (max-width: 984px) 61vw, (max-width: 1362px) 45vw, 600px" data-recalc-dims="1" /> <figcaption>Squash Ball Feet</figcaption></figure> 

The feet were easy to print, and work well. They do make the printer quite a lot higher though (~51cm total from base to top), but they dramatically reduce ghosting effects.

## PSU Replacement Fan Cover

The PSU fan on this unit is horribly loud. I put this down to there being hardly any clearance between the thin aluminium shell of the PSU and the metal bottom plate, so it vibrates awfully. So, I printed a replacement PSU fan cover from [Thingiverse](http://www.thingiverse.com/thing:3306465) (the 60mm version) and installed the recommended Noctua FLX fan.<figure class="wp-block-image">

<img src="https://i1.wp.com/blog.zencoffee.org/wp-content/uploads/2019/04/psu_cover.jpg?fit=840%2C525&ssl=1" alt="" class="wp-image-1138" srcset="https://i1.wp.com/blog.zencoffee.org/wp-content/uploads/2019/04/psu_cover.jpg?w=2352&ssl=1 2352w, https://i1.wp.com/blog.zencoffee.org/wp-content/uploads/2019/04/psu_cover.jpg?resize=300%2C188&ssl=1 300w, https://i1.wp.com/blog.zencoffee.org/wp-content/uploads/2019/04/psu_cover.jpg?resize=768%2C480&ssl=1 768w, https://i1.wp.com/blog.zencoffee.org/wp-content/uploads/2019/04/psu_cover.jpg?resize=1024%2C640&ssl=1 1024w, https://i1.wp.com/blog.zencoffee.org/wp-content/uploads/2019/04/psu_cover.jpg?resize=1200%2C750&ssl=1 1200w, https://i1.wp.com/blog.zencoffee.org/wp-content/uploads/2019/04/psu_cover.jpg?w=1680&ssl=1 1680w" sizes="(max-width: 709px) 85vw, (max-width: 909px) 67vw, (max-width: 1362px) 62vw, 840px" /> <figcaption>Replacement PSU Cover</figcaption></figure> 

I'm not terribly impressed with the print, it fits, but it's off by a little. It works OK though. I'm also not enthralled with using PLA for something that may be exposed to heat, but I wanted to be sure of the amount of cooling I had before I did a big print in ABS - one of my first projects with the fire retardant ABS I have on order is to print a replacement cover for this in that. But it dramatically cuts down noise while improving airflow.

## Controller and Stepper Drivers

I haven't replaced these, but here's a view of the Trigorilla control board with the default stepper drivers;<figure class="wp-block-image">

<img src="https://i2.wp.com/blog.zencoffee.org/wp-content/uploads/2019/04/controller_and_steppers.jpg?fit=608%2C1024&ssl=1" alt="" class="wp-image-1139" srcset="https://i2.wp.com/blog.zencoffee.org/wp-content/uploads/2019/04/controller_and_steppers.jpg?w=1960&ssl=1 1960w, https://i2.wp.com/blog.zencoffee.org/wp-content/uploads/2019/04/controller_and_steppers.jpg?resize=178%2C300&ssl=1 178w, https://i2.wp.com/blog.zencoffee.org/wp-content/uploads/2019/04/controller_and_steppers.jpg?resize=768%2C1294&ssl=1 768w, https://i2.wp.com/blog.zencoffee.org/wp-content/uploads/2019/04/controller_and_steppers.jpg?resize=608%2C1024&ssl=1 608w, https://i2.wp.com/blog.zencoffee.org/wp-content/uploads/2019/04/controller_and_steppers.jpg?resize=1200%2C2022&ssl=1 1200w, https://i2.wp.com/blog.zencoffee.org/wp-content/uploads/2019/04/controller_and_steppers.jpg?w=1680&ssl=1 1680w" sizes="(max-width: 709px) 85vw, (max-width: 909px) 67vw, (max-width: 1362px) 62vw, 840px" /> <figcaption>Trigorilla Board with default stepper drivers</figcaption></figure> 

I have a set of replacement stepper drivers on order, which should improve print quality and resolution markedly. I'll install those when I have replacement internal components printed in ABS.

## Stepper Driver Cooling Duct

The default cooling setup for the stepper drivers is woeful. It features a fan with about 1mm of clearance to a solid steel section of the bottom plate, meaning there is virtually no airflow over the stepper drivers. Considering these generate a lot of heat, this design is pretty poor. So, we simply print a stepper driver cooling duct from [Thingiverse](https://www.thingiverse.com/thing:2878826). <figure class="wp-block-image">

<img src="https://i2.wp.com/blog.zencoffee.org/wp-content/uploads/2019/04/stepper_duct.jpg?fit=801%2C1024&ssl=1" alt="" class="wp-image-1140" srcset="https://i2.wp.com/blog.zencoffee.org/wp-content/uploads/2019/04/stepper_duct.jpg?w=1959&ssl=1 1959w, https://i2.wp.com/blog.zencoffee.org/wp-content/uploads/2019/04/stepper_duct.jpg?resize=235%2C300&ssl=1 235w, https://i2.wp.com/blog.zencoffee.org/wp-content/uploads/2019/04/stepper_duct.jpg?resize=768%2C982&ssl=1 768w, https://i2.wp.com/blog.zencoffee.org/wp-content/uploads/2019/04/stepper_duct.jpg?resize=801%2C1024&ssl=1 801w, https://i2.wp.com/blog.zencoffee.org/wp-content/uploads/2019/04/stepper_duct.jpg?resize=1200%2C1534&ssl=1 1200w, https://i2.wp.com/blog.zencoffee.org/wp-content/uploads/2019/04/stepper_duct.jpg?w=1680&ssl=1 1680w" sizes="(max-width: 709px) 85vw, (max-width: 909px) 67vw, (max-width: 1362px) 62vw, 840px" /> <figcaption>Stepper Driver Cooling Duct</figcaption></figure> 

This uses a 40mm Noctua FLX fan, and due to the design you can only actually fit it while the power supply is out. But it does fit, and provides a directed flow of air straight over the stepper drivers and out of the case. I also intend to reprint this in fire retardant ABS.

## Final Notes

It's pretty ingenious that you can print upgrades and fixes for your own printer. However, note that your ability to print upgrades depends on the upgrades you have already printed working! So I would strongly suggest that when you find a working upgrade that is critical to the functioning of the printer (eg, tensioners) that you print two of them. I also ordered spare drive belt (GT2x6 pulley belt) and some spare pulleys, since I expect a belt will go at some stage, and I can't reprint that.

Next up I'm printing some [cable chains](http://www.thingiverse.com/thing:2705730) to help keep things neater. I also printed a [side mount](http://www.thingiverse.com/thing:3511248) for an OctoPi which houses a camera, but I don't know if I'll use that in the end, it depends how I do my final setup.

I also made a Wemos-powered [status monitor](http://www.thingiverse.com/thing:2884823) that can sit on my desk, but that warrants its own post.

Lastly, I'm looking into making an [enclosure](http://www.thingiverse.com/thing:2978880) using some IKEA Lack tables and printed fittings for them, but that will also warrant its own post.