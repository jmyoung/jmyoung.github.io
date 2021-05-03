---
title: AnyCubic i3 Mega with TMC2208 Drivers
date: 2020-04-15T17:00:00+09:30
author: James Young
layout: post
categories:
  - 3d Printing
tags:
  - 3dprinting
  - anycubic
---
  
I finally got around to installing the TMC2208 stepper drivers into my AnyCubic i3 Mega the other day.  I bought a set of FYSETC TMC2208 v1.2 stepper drivers ages ago, but never got around to actually installing them.

**2020 Update: if you do this yourself, you should probably use [FYSETC TMC2209 V3.0](https://wiki.fysetc.com/Silent2209/) drivers instead of the TMC2208's I've used.**

In addition, David Ramiro, who's been working on the customized Marlin firmware for the AnyCubic i3 Mega has a **BETA** release branch for [Marlin 2.0.x](https://github.com/davidramiro/Marlin-Ai3M-2.0.x), which also has a precompiled HEX file for using the TMC2208 drivers. The coil wiring on the TMC2208 is reversed, so it's necessary to either reverse your connectors, or install a firmware which has them swapped already.

Installation is quite straightforward, just literally follow the guide.  However there is one step that is not described, and it's a doozy.

On my board, which is a Trigorilla 1.0 8-bit based on an ATmega2560, on a 03 series AnyCubic, there are six stepper connectors; X,Y,Z,Z,E0,E1.  Under older Marlin firmware and the stock firmware, the cables were connected like so;

| Label | Actual Stepper (Stock) |
| --- | --- |
| X | Carriage Stepper |
| Y | Bed Stepper |
| Z | Right Vertical Stepper |
| Z | Not Connected |
| E0 | Extruder Stepper |
| E1 | Left Vertical Stepper |

This...  doesn't work with newer firmware releases.  If you try and use this, the left vertical stepper is not driven and this is *very bad*.

The solution is simple, once I figured it out.  Pull the cable that was plugged into E1 and plug it into the second Z port (the bottom one).

| Label | Actual Stepper (2.0.x) |
| --- | --- |
| X | Carriage Stepper |
| Y | Bed Stepper |
| Z | Right Vertical Stepper |
| Z | Left Vertical Stepper |
| E0 | Extruder Stepper |
| E1 | Not Connected |

This works just fine like this.  The results are pretty great.  The TMC2208's are **much, much quieter**, and appear to produce less ringing and other artefacts when printing.

You should be able to connect up UART control for the drivers so that you can adjust the drive voltage and so-on, and you can also adjust them simply with the potentiometer on them, but I haven't done that.  I've just installed them as stock.  I might mess with that another time when I have the back off again.
