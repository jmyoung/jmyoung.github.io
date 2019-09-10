---
id: 776
title: Using ADB in Recovery Mode
date: 2014-09-23T10:50:51+09:30
author: James Young
layout: post
guid: http://blog.zencoffee.org/?p=776
permalink: /2014/09/using-adb-recovery-mode/
categories:
  - Computers
  - Mobile Devices
  - Technical
tags:
  - android
  - i9305
  - security
---
I don't have a specific use case for this, but I thought I'd experiment and see just how this can be done.  I've recently changed over to encryption on my smartphone, because it came to my attention that it's possible to use the Android debugger to get access to an Android device's flash even if you don't have the unlock pin.  This of course requires physical access to the phone.

This procedure illustrates why it's a damned good idea to encrypt your phone.

# Step 1 - Install ADB

Go to [this link](http://developer.android.com/sdk/installing/index.html?pkg=studio) and download the Android SDK and install it.  Install to the default location.  Since there's a good chance you don't have a 64-bit JDK installed too, go to [this link](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html) and download the latest JDK for Windows x64.  Install that too.

You'll probably also have to create a JAVA_HOME environment variable.  That's described in the first link.

# Step 2 - Install SDK Packages

Run Android Studio as Administrator.  Click Configure.  Click SDK Manager.  Click "Deselect All" then "Select Updates".  Now, tick "Android SDK Platform-tools" under Tools, and "Google USB Driver" under Extras.  Click Install and follow the wizard.  Close the SDK Manager when done.

Close Android Studio.

# Step 3 - Connect your device to ADB

Power off the phone, plug it into your computer and power it up in Recovery mode with (this is for a Samsung Galaxy S3) holding down the power button, volume up and menu at the same time.  Let go of the power button when the screen comes on.

If you don't have a recovery installed, you'll have to boot into the bootloader (same buttons as above just use volume down instead), and then [use Fastboot to install a custom recovery](http://www.teamandroid.com/2012/07/30/how-to-set-up-adb-fastboot-with-android-sdk/) (like CWM or TWRP).

Once in Recovery, go to Device Manager on your PC, and change the driver for the phone.  I used the [SAMSUNG Android ADB Interface](http://developer.samsung.com/android/tools-sdks/Samsung-Android-USB-Driver-for-Windows) driver.

Then, fire up a command prompt in Administrator mode, go to "C:\Program Files (x86)\Android\android-studio\sdk\platform-tools" and run "adb shell"

You're now in a basic recovery shell on the phone.  From here, you can now do pretty well whatever you want - read data, [copy stuff off the phone](http://techglen.com/2014/01/29/how-to-recover-data-using-adb-recovery-on-android/), [rewrite the recovery](http://lifehacker.com/the-most-useful-things-you-can-do-with-adb-and-fastboot-1590337225), [change the unlock PIN](http://forum.xda-developers.com/showthread.php?t=1409304), whatever.

Have fun.  Use your newfound powers for good, not evil.