---
id: 1116
title: AnyCubic i3 Mega Tuning
date: 2019-04-10T13:19:58+09:30
author: James Young
layout: post
guid: https://blog.zencoffee.org/?p=1116
permalink: /2019/04/anycubic-i3-mega-tuning/
categories:
  - 3d Printing
---
After having my AnyCubic for a week, I've done a fair bit of tuning and mucking about. I've printed several benchmarking prints and calibrated the steppers. It's printing fairly well now. Here's what I did.

## Initial Calibration

Firstly, you'll need a set of calipers - a ruler isn't good enough. Then, consult the following guide;

[3D Printer Calibration Guide](https://all3dp.com/2/how-to-calibrate-a-3d-printer-simply-explained/)

The very first step is to get the first layer adjusted. Fortunately with Marlin, this is quite easy and you can use mesh bed levelling. Get the bed fairly flat initially using the normal levelling technique that the AnyCubic includes, then follow [this guide](https://www.thingiverse.com/thing:3249319#manual-mesh-bed-leveling). Use a thin piece of paper (thermoprint receipt paper is perfect), and do it while the bed and nozzle is hot.

After you're done, send the following G-Code commands to print a levelling test (200 degree hot end, 60 degree bed);

<pre class="wp-block-code"><code>G28
G26 C H200 P5 R25 Q4.2 Z4</code></pre>

The next part is to calibrate the extruder stepper. I measured out 130mm of filament, and told it to extrude 100mm. A longer length gives better accuracy. Read the calibration guide for instructions.

After doing that, measure the thickness of your filament in a few points and adjust the filament thickness in Cura to suit. In my case, my filament is a LOT thicker than 1.75mm (it's actually 1.98mm), which makes a difference to extrusion and can throw off the next test.

Now you have your extruder calibrated, you can print a [calibration cube](https://www.thingiverse.com/thing:1278865). After that's printed, you can measure its dimensions and then adjust your XYZ steppers.

At this point, all your axes should be calibrated, your bed is level, and you know how thick your filament is - so the majority of the dimensional calibrations are done.

## Temperature Tuning

You next need to print a [temperature tower](https://www.thingiverse.com/thing:2729076). However, this will require some manipulation in Cura to make it work. Consult the readme, and in there you will find a list of the layer Z heights that should correspond to what temperatures.

From there, you can use Cura extensions to fix it. Set your print temperature to 180 (which corresponds to the "floor" temperature setting in the readme), then click Extensions->Post-Processing -> Modify G-Code.

Click Add a Script, then ChangeAtZ. Specify the height as per the README, then check the "Change Extruder 1 Temp" box, and enter the temperature for that height from the readme. Click Add a script again, and repeat. You'll need to do this a bunch. Sorry.

Print it off, and then examine it. Select the temperature that looks best (for me that was 190 degrees), and that will be your new default print temperature.

## Cura Profile Tuning

Right. Now you've done that, it's time to adjust your Cura profile. What works for you may be different from what works for me, but I adjusted the following settings and got fairly good results so far (this is all based from the default Normal profile);

  * **Quality**
      * Layer Height: 0.2mm
      * Initial Layer Height: 0.3mm
  * **Shell**
      * Wall Thickness: 1.2mm
      * Top Surface Skin Layers: 1
      * Top/Bottom Thickness: 1.2mm
      * Enable Ironing: OFF
  * **Infill**
      * Infill Density: 20%
  * **Material**
      * Default Printing Temperature: 190
      * Build Plate Temperature: 60
      * Build Plate Temperature Initial Layer: 70
      * Retraction Distance: 6.5mm
      * Retraction Speed: 50mm/s
  * **Speed**
      * Print Speed: 60mm/s
      * Infill Speed: 60mm/s
          * Outer Wall Speed: 45mm/s
          * Inner Wall Speed: 60mm/s
      * Top/Bottom Speed: 30mm/s
      * Support Speed: 80mm/s
          * Support Interface Speed: 40mm/s
      * Print Acceleration: 1800mm/s
      * Print Jerk: 8mm/s
  * **Travel**
      * Combing Mode: Not in Skin
      * Z Hop When Retracted: YES
  * **Cooling**
      * Fan Speed: 80%
      * Initial Fan Speed: 0%
      * Regular Fan Speed at Layer: 4
  * **Support**
      * Generate Support: YES
      * Support Placement: Touching Buildplate
      * Support Overhang Angle: 60
      * Support Density: 15%
  * **Build Plate Adhesion**
      * Build Plate Adhesion Type: Brim

Some words about why these settings were picked is relevant - some of them I haven't actually tweaked, but I know they are relevant.

  * **Quality:** Layer Height is picked according to the resolution you want. The initial layer is selected to be 0.3mm to aid plate adhesion.
  * **Shell:** Thicknesses can be reduced if you want a faster print at the expense of speed. 0.8mm is a common choice. Ironing will get the nozzle to wipe over the top layer to smooth it off.
  * **Infill:** Change density as desired for part strength.
  * **Material:** 190/60 fits my filament well. The initial layer temperature promotes good adhesion of the first layer to the bed, hence the elevated temperature. Retraction distance and speed were tweaked to reduce stringing effects.
  * **Speed:** Print speeds can be adjusted downwards, but I wouldn't adjust them upwards. These fit the recommended speeds of the AnyCubic. The outer walls and top/bottom are slower to promote better surfaces. I haven't tweaked the acceleration and jerk much, but they are enabled so I can mess with them later.
  * **Travel:** Changing Combing Mode will reduce the effect where strings are placed just under the skin layers, leading to ugly looking tops/bottoms. There is a small cost in print speed, but in my opinion it's worth it.
  * **Cooling:** The fan at 100% is rather excessive, hence ratcheting it down. The initial fan speed and layer settings promote better bed adhesion by reducing cooling for the first few layers, which then ramps up as the print proceeds.
  * **Support:** I set Touching Buildplate so I don't get internal supports, which are horrible to remove. This needs to be tweaked as per your needs.
  * **Build Plate Adhesion:** Brim adhesion prints a single-layer brim around your piece. It greatly improves adhesion and reduces warping, and is pretty easy to remove from a finished piece with your fingernails. Worth having as a default.

## Start G-Code Customization

Ok. After all the above is done, you should have your temperatures dialed in, Cura set up with some useful parameters, and your axes all calibrated. Your bed should be flat. Next up is to tweak the G-Code used to start the build.

I've selected to perform a nozzle wipe procedure after initial setup. This procedure prints a short line of filament at the front of the bed before wiping the nozzle away to clear it.

The G-Code I'm using for Start G-Code looks like this;

<pre class="wp-block-preformatted">;;;;; cura zeroing with nozzle wipe ;;;;;<br />G21 ;metric values <br />G90 ;absolute positioning <br />M82 ;set extruder to absolute mode <br />M107 ;start with the fan off <br />G28 X0 Y0 ;move X/Y to min endstops <br />G28 Z0 ;move Z to min endstops <br />M501 ;marlin load eeprom <br />M420 S1 ;marlin use mesh levelling <br />G0 X0 Y0 Z0.15 F{speed_travel} ;move 0.15mm from front left corner of platform <br />G92 E0 ;zero the extruded length <br />G1 X40 E25 F{speed_layer_0} ;extrude 25mm of filament in a 4cm line at initial layer print speed <br />G92 E0 ;zero the extruded length again <br />G1 E-1 F{wipe_retraction_speed} ;retract 1mm <br />G1 X80 F4000 ;quick wipe from the filament line <br />G1 Z15.0 F{speed_travel} ;move the platform down 15mm <br />G1 F{speed_travel} <br />M117 Printing... <br />G5</pre>

This is pretty similar to the default Cura settings for the AnyCubic. A few things warrant talking about though.

The M501 / M420 steps enable the Mesh Levelling you set up in Marlin. This should be done just after reaching the home position.

The steps after mesh leveling and before the final platform position change (setting the head 15mm above the platform) perform the wipe.

If you don't want to do this, replace that section (including the G1 Z15.0 step) with;

<pre class="wp-block-preformatted">G1 Z15.0 F{speed_travel} ;move the platform down 15mm<br />G92 E0 ;zero the extruded length<br />G1 F200 E3 ;extrude 3mm of feed stock<br />G92 E0 ;zero the extruded length again</pre>

That is the Cura defaults. The above settings should produce decent results.

## Phew! What now? 

Ok, that was a lot. Now that's done, I'm printing various other bits and pieces for the printer - more will come as I get it done.

Oh, and if you've set up the printer and want to give it a stress test, print a [3dBenchy](http://www.3dbenchy.com/) with no supports enabled. See how it goes!