---
id: 1093
title: Necromancy and the Garmin Nuvi 1390
date: 2018-12-03T13:10:57+09:30
author: James Young
layout: post
guid: https://blog.zencoffee.org/?p=1093
permalink: /2018/12/necromancy-and-the-garmin-nuvi-1390/
categories:
  - Electronics
---
My father asked me to update the maps on his Garmin Nuvi 1390 on Friday evening.  This did not go so well.  Using Garmin Express, I applied the updates, unplugged it when it said, and it sat there with a black screen saying "Loading maps." and that was all.  Nothing else.

Whoops.  Anyway, a lot of digging revealed that what was going on is that the GPS couldn't boot, likely due to corruption in the filesystem.  So here's how to fix that.

You first need [Garmin Cure 3](https://www.gpspower.net/garmin-receivers-firmwares/246273-garmincure3-tool-new-way-create-cure-firmwares-garmin-devices.html).  This is kicking around in various places, but you can get it at that link.  You also need the firmware image for the current firmware you have installed, which you can find [here](http://gawisp.com/perry/).  And you need a tool to reformat the mass storage (if this is required), which you can use [RMPrepUSB](http://www.gpspower.net/garmin-tutorials/252968-how-properly-format-nuvi-after-using-kunixs-cure.html#post800219html) for.  I'll assume you have Garmin Connect or something installed so you have the USB drivers.

# Getting access to the Mass Storage

After installing all the above, you'll need to fire up Garmin Cure 3, point it at the firmware image you downloaded, then put it into CURE mode, and start it.  At this point the GPS should be turned off and unplugged.  Wait until it says it's ready to load, then click the Updater button to launch the updater.

Now, you need to get the GPS into pre-boot mode.  On the Nuvi 1390, that involves holding your finger on the top left corner of the screen and turning it on.  Keeping your finger on the screen, plug in the USB cable, wait for Windows to make the "device connected" sound, and click to let the updater work.

# Fixing Mass Storage Issues

Assuming you now get firmware up, what will happen is that you have the CURE firmware on.  This firmware will not load, but when you boot the GPS up and plug it into your computer, you should get the GPS appear as a mass storage device.  Let's assume it does.  You can now copy off anything you want, try and fix it, or like in my case, reformat it.

If you reformat, you can use RMPrepUsb to do so.  Follow the instructions at [this link](https://www.gpspower.net/garmin-tutorials/252968-how-properly-format-nuvi-after-using-kunixs-cure.html#post800219html) to do so.  Notably, the Nuvi 1390 doesn't care if the filesystem is blank when you first boot it.  Doing this will wipe anything you downloaded or anything factory loaded such as car icons, the sample [Cyclops](https://buy.garmin.com/en-AU/AU/p/68086) database and other things like that.

# Restoring the Original Firmware and Updating

After that's done, unplug the GPS, turn it off.  Repeat the above CURE process, but this time select ORIGINAL as the option.  This will put normal firmware on.  You should now be able to boot your device.  Run Garmin Express and update it.  Tell it to reinstall the maps, which will take a while, and you should be (mostly) back to normal.

# Installing a POI Database

Restoring like this will destroy the sample Cyclops safety camera database.  That's OK, we'll replace it.  Using a website like [PoiDB](http://www.poidb.com/groups/group.asp?GroupID=110), get hold of a POI database in GPX format.  You will now need to install [Garmin's POI Loader](https://www8.garmin.com/support/download_details.jsp?id=927), then point the Loader at the GPX you downloaded.  Follow the prompts and it will insert that POI database in GPI format into your GPS, and your safety camera alerts should be restored.

Notably though, and this is annoying, the safety camera alerts won't be colorized for your speed or anything, but they'll be there.  If you have actually paid for Cyclops you can probably just get the proper Cyclops DB installed by just using Garmin Express and don't need to use a community-made POI database like I did.

Good luck.