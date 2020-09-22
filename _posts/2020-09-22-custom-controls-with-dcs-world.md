---
title: Custom Controls with DCS World
date: 2020-09-22T9:45:00+09:30
author: James Young
layout: post
categories:
  - Gaming
tags:
  - dcs
---

I've been playing [DCS World](https://www.digitalcombatsimulator.com/en/products/world/) a fair bit more lately, specifically the [F/A-18C](https://www.digitalcombatsimulator.com/en/shop/modules/hornet/) module.  I have a [HOTAS Warthog](http://www.thrustmaster.com/products/hotas-warthog/) controller, which is pretty great, but unfortunately the switches can be a bit deficient when you're playing something that is not an A-10C.

Specifically, the way they are implemented.  The two-way bistable switches are implemented as a single 'button' in the DirectInput controller, with "on" being in one state, and "off" being the other state.  For example, the "EAC ARM/OFF" switch at the bottom left maps to DirectInput button 24, and when in the "ARM" position it's down.  In the off position it's up.

Where you run into a problem is where you need a command to be triggered for _each_ state, not just one of them.  So if you want to map your landing gear to that switch, you are either forced to use button 24 as a toggle (and therefore have to flick the switch from up to down back to up again to do something), or find some other solution.

So here's the other solution.  Edit the command mappings!  Hans-Werner Fassbender wrote an excellent PDF on the matter, [How to Edit Control Binding Files](https://forums.eagle.ru/attachment.php?attachmentid=179439&d=1519039477) (sorry, I can't find the original thread).  I won't go into gory detail on that right now, the PDF is excellent and explains the process very well.

One note though, don't interfere with the tabbing and spacing in the existing commands.  If you get it wrong, you'll know because you won't be able to map anything to your joysticks any more.

So what I've done is mapped EAC ARM/OFF to the landing gear up/down, RDR ALTM NRM/DIS to altitude switch BARO/RDR, and the ENG fuel flow right switch to Arresting Hook Handle UP/DOWN.

The fuel probe extend/retract works as-is on the other fuel flow switch, and the launch bar extend/retract works fine on the APU start switch.

Here's the LUA fragment I used in case anyone else wants it.

```lua
-- START Customized Controls
{ 
  down = iCommandPlaneGearUp, 
  up = iCommandPlaneGearDown, 
  name = _('Landing Gear Control Handle - UP/DOWN (Custom)'), 
  category = {_('Custom Controls')}
},
{ 
  down = gear_commands.HookHandle, value_down = 1.0, 
  up = gear_commands.HookHandle, value_up = 0.0, 
  cockpit_device_id = devices.GEAR_INTERFACE, 
  name = _('Arresting Hook Handle - UP/DOWN (Custom)'), 
  category = {_('Custom Controls')}
},
{ 
  down = HUD_commands.HUD_AltitudeSw, value_down = 1.0,
  up = HUD_commands.HUD_AltitudeSw, value_up = 0.0,
  cockpit_device_id = devices.HUD,
  name = _('Altitude Switch - BARO/RDR (Custom)'),  
  category = {_('Custom Controls')}
},
-- END Customized Controls
```
You'll need to replicate those changes after each update, most likely.  Annoying, but eh, that's how it goes I guess.
