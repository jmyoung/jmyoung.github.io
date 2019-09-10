---
id: 5
title: Installing a CyanogenMod ROM onto a GT-i9305
date: 2013-03-15T05:41:00+09:30
author: James Young
layout: post
guid: http://wordpress/wordpress/?p=5
permalink: /2013/03/installing-a-cyanogenmod-rom-onto-a-gt-i9305/
blogger_blog:
  - coding.zencoffee.org
blogger_author:
  - James Young
blogger_permalink:
  - /2013/03/installing-cyanogenmod-rom-onto-gt-i9305.html
categories:
  - Mobile Devices
tags:
  - android
  - cyanogenmod
  - i9305
---
<span style="color: #ff0000;"><b>DANGER!  Installing a custom recovery and firmware can void your warranty, and in some rare circumstances render your phone irrevocably bricked (broken).  Be aware of what you're doing when you do this, and be aware of the consequences of installing third-party firmware.  I can't be held responsible if your phone is bricked, buggy, or anything bad happens as a result of doing this.  </b></span>

Notably, any firmware intended for the GT-i9305 will work with a GT-i9305T.  They're the same phone, although the radio firmware likely differs.  We won't be messing with radio firmware though.

Getting a custom firmware onto a GT-i9305 comes in a couple of steps;

  * Install a custom recovery.  We'll use [ClockworkMod](http://www.clockworkmod.com/) for this.
  * Take a nandroid backup of the phone using CWM (pre-rooting).
  * Root the phone so that we have superuser access and can install [TitaniumBackup](https://play.google.com/store/apps/details?id=com.keramidas.TitaniumBackup&hl=en) 
  * Then, we'll root the phone, which lets you have superuser access.
  * Take backups of everything with TitaniumBackup.
  * Back up the IMEI / NVRAM data (the i9305 stores IMEI data on flash, so it's possible for a bad firmware flash to wipe your IMEI, which is really really bad).
  * Reboot into CWM and flash the CyanogenMod 10.1 build ZIP.
  * Factory reset the phone.
  * Set it back up again.

Now, a couple of things we need to get out of the way;

## Recovery Boot Modes

In order to boot to ClockworkMod Recovery mode, turn off the phone, and hold volume UP + Home + Power.  When you see the Samsung splash screen, let go of the power button, but keep holding down the other two until you see CWM's boot screen.

In order to boot to Download Mode (used with ODIN), turn off the phone, and hold volume DOWN + Home + Power.  When you see the Samsung splash screen, let go of the power button, but keep holding the other two until you see the big Android warning.  Follow the prompts.

## Host OS Choice

I did all this on a Windows 7 x64 box.  You can theoretically do this with Linux, but I haven't tried.  Your mileage may vary with other OSes.

Let's get cracking!

<!--more-->

## A - Install ClockworkMod

Reference: <http://forum.xda-developers.com/showthread.php?t=1914394>

  * Download the latest ClockworkMod Recovery for the GT-i9305 ( [GT-I9305\_ClockworkMod-Recovery\_6.0.2.7.tar](http://forum.xda-developers.com/showthread.php?t=2140681) ).
  * Download the relevant Odin3 firmware flashing utility and unzip it to a folder somewhere ( <http://forum.xda-developers.com/showthread.php?t=1738841> )
  * Turn the phone off and boot into Download Mode.
  * Run Odin3 by running the EXE you extracted.  Once Odin is running, plug in your phone.  You should see ID:COM change color and a message saying 'ADDED' appear.
  * Click the PDA button and locate the ClockmodRecovery file you downloaded earlier.  Make sure that the Repartition checkbox is NOT selected.
  * Click Start.  If everything is great you'll see a message saying 'PASS'.  The phone will then reboot itself.

You now have CWM installed.  Unplug the phone.

## B - Take a nandroid backup of the phone

Boot into CWM, then select 'Backup to external SD card (you do have an external SD card on this thing, right?).  Run the backup, and it will take a backup of your flash as it stands so you can recover from most instances of a broken firmware install.

## C - Root the phone and install TitaniumBackup

Reference:  <http://www.androidegis.com/how-to/learn-how-to-root-galaxy-s3-lte-gt-i9305/>

Follow the instructions in the above reference to flash the appropriate rooting package into your current firmware.  Once you've done that, go and install TitaniumBackup.

Run TitaniumBackup, in the preferences change the backup location to your SD card, and run a full backup to get copies of all your apps onto the card.  This may prove very valuable in case you forget something.

## D - Back up the IMEI / NVRAM Data

Reference:  <http://forum.xda-developers.com/showthread.php?t=1946915>

Get the files and other instructions from the above link.

Configure QPST to work with your computer;

  * Dial *#7284# on your phone to access PhoneUtil and select 'Qualcomm USB Settings' at the bottom. Now select 'RNDIS + DM + MODEM' and press 'OK' to return to the previous screen. Now press your 'Back' key to exit PhoneUtil. Your phone is now in DIAG Mode.
  * Download and Install: SAMSUNG\_USB\_Driver\_for\_Mobile\_Phones\_1590.exe - 23.06 MB if you don't already have Kies or a USB Driver installed.
  * Download and Install: QPST v2.7.378.zip - 14.68 MB
  * Now connect your phone to the PC with a USB cable and wait for Drivers to install.
  * Start the 'QPST Configuration' application and select the 'Ports' tab then press the 'Add New Port...' button.
  * Select the COM Port that has 'USB/QC Diagnostic' next to it, change the Port Label if you like to 'Samsung GT-I9305' then press 'OK'.
  * You should now see your phone listed in the 'Ports' tab and the 'State' should indicate 'Enabled'.

Back up the IMEI / NV Data;

  * Start the 'Software Download' application and select the 'Backup' tab.
  * Press the 'Browse' button and choose a Save Location for your QCN File.
  * Press the 'Start' button and wait for it to finish. This will back up all your phones NV Items and save them to the QCN Backup File.
  * The resulting QCN Backup File should be 250KB.

Restore USB Settings to default after Backup / Restore;

  * Dial *#7284# on your phone to access PhoneUtil and select 'Qualcomm USB Settings' at the bottom. Now select 'MTP + ADB' and press 'OK' to return to the previous screen. Now press your 'Back' key to exit PhoneUtil. Your phone is now back to default USB operation.

## E - Get a copy of your modem firmware

Reference:  http://forum.xda-developers.com/showthread.php?t=2010116

Check your phone's baseband revision in Settings -> About Phone.  My baseband original version was DVALI5, so go to the link above and download that.  If you somehow wreck your baseband firmware, you'll need that file to restore it.  I've since upgraded mine to the latest for the GT-I9305T.

## F - Check your backups!

You should have the following backup files.  I'd strongly suggest copying these off to a PC somewhere just in case;

  * The original Nandroid backup you took (pre-rooting)
  * The nandroid backup you are going to take just before flashing CyanogenMod 10.1
  * The contents of your TitaniumBackup repository containing backups of all your apps
  * Your IMEI/NV data files (.QCN)
  * The modem firmware ZIP for your current baseband revision

With all that in hand, you're ready to take the plunge...

## G - Install CyanogenMod 10.1

Reference:  <http://forum.xda-developers.com/showthread.php?t=2157651>  
Google Apps Export:  <http://goo.im/gapps>

**NOTE - You only have to do the full wipe when going from a different firmware to CM 10.1.**

  * Copy the CM 10.1 installation ZIP file (either downloaded or built yourself) onto your SD card.
  * Copy the Google Apps export from the link above (download the one for CyanogenMod 10.1.x) onto your SD card.
  * Boot into CWM recovery mode.
  * Select to flash a zip from external SD card, and flash the CM 10.1 installation zip.
  * Select to flash a zip again, and flash the Google Apps zip.
  * Without rebooting, select to a 'wipe data / factory reset'.  Let it go through.  This will clear all the cache and data partitions, leaving you with a 'factory' CM 10.1 phone.
  * Reboot the phone.
  * You will now have to set your phone up again.

Notably, do not restore system apps using Titanium Backup!  You're best off reinstalling an app and then reconfiguring it if you can possibly get away with it.  Non-system apps are probably OK for you to restore with Titanium Backup, but watch out when trying to restore Apps + Data.

**NOTE - Your battery life will probably suck for the first day while everything gets cached.  It should get better pretty quickly though.** 

## Appendix - Upgrade to a new release of CM 10.1

To upgrade, just copy the zip to your SD card, boot into CWM, then flash the zip.  No factory wipe is required if you're just updating an already in place CM 10.1 build.

## Appendix - Upgrade radio/modem firmware

To flash a new radio firmware, copy the zip to your SD card, boot into CWM and flash it.  If you have problems, flash your original firmware back again (that's why you downloaded that firmware first).

Good luck!