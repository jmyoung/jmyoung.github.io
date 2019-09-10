---
id: 6
title: CyanogenMod 10.1 for the GT-i9305 from source
date: 2013-03-15T03:35:00+09:30
author: James Young
layout: post
guid: http://wordpress/wordpress/?p=6
permalink: /2013/03/cyanogenmod-10-1-for-the-gt-i9305-from-source/
blogger_blog:
  - coding.zencoffee.org
blogger_author:
  - James Young
blogger_permalink:
  - /2013/03/cyanogenmod-101-for-gt-i9305-from-source.html
categories:
  - Mobile Devices
tags:
  - android
  - cyanogenmod
  - i9305
---
<div>
  <a href="https://i2.wp.com/4.bp.blogspot.com/-e2Ryh34-vDs/UUJ4C9qBKxI/AAAAAAAAANM/ecKhMzge4-c/s1600/Screenshot_2013-03-15-10-36-28.png"><img class="alignright" style="border: 0px currentColor;" alt="" src="https://i0.wp.com/4.bp.blogspot.com/-e2Ryh34-vDs/UUJ4C9qBKxI/AAAAAAAAANM/ecKhMzge4-c/s320/Screenshot_2013-03-15-10-36-28.png?resize=180%2C320" width="180" height="320" border="0" data-recalc-dims="1" /></a>
</div>

Bit the bullet, and built my own [CyanogenMod](http://www.cyanogenmod.org/) 10.1 for my GT-i9305T phone from source.  Works great, and that means I now have Android 4.2.2 on it!

Following is a quick piece on how to build your own CM 10.1 from source for the i9305.

First, some info, then we'll get into it;

## Reference Links

<http://forum.xda-developers.com/showthread.php?t=1971645>  
<http://forum.xda-developers.com/showthread.php?p=33038053>  
<http://forum.xda-developers.com/showthread.php?t=2157651>

## Machine Prep

I used an Ubuntu 12.10 x64 virtual machine running under VMware Workstation.  Give the machine a pretty fair amount of CPU and RAM (I went 4Gb ram and 4 vCPU since I have a quad-core box).  Build times are heavily limited by CPU.

You will also need a significant amount of disk space.  The built source tree takes up about 35Gb, so go with a 50Gb VM and you should have enough.

Once done, update the machine entirely, then from a Terminal prompt, run this to download pre-requisites;

<pre>  sudo apt-get install git-core gnupg flex bison gperf build-essential \
      zip curl libc6-dev libncurses5-dev:i386 x11proto-core-dev \
      libx11-dev:i386 libreadline6-dev:i386 libgl1-mesa-glx:i386 \
      libgl1-mesa-dev g++-multilib mingw32 openjdk-6-jdk tofrodos \
      python-markdown libxml2-utils schedtool pngcrush xsltproc zlib1g-dev:i386
  sudo ln -s /usr/lib/i386-linux-gnu/mesa/libGL.so.1 /usr/lib/i386-linux-gnu/libGL.so</pre>

## Repository Synchronization

Download the repo tool and set it up;

<pre>    mkdir ~/bin
    PATH=~/bin:$PATH
    cd ~/bin
    curl https://dl-ssl.google.com/dl/googlesource/git-repo/repo &gt; ~/bin/repo
    chmod a+x ~/bin/repo</pre>

Create source repo for CyanogenMod and then synchronize;

<pre>    mkdir ~/cm10.1
    cd ~/cm10.1
    repo init -u git://github.com/CyanogenMod/android.git -b cm-10.1
    repo sync</pre>

Create the file ~/cm10.1/.repo/local_manifests/i9305.xml with this text;

<pre>&lt;manifest&gt;
        &lt;project name="CyanogenMod/android_device_samsung_i9305" path="device/samsung/i9305" remote="github" revision="cm-10.1"/&gt;
        &lt;project name="CyanogenMod/android_device_samsung_smdk4412-common" path="device/samsung/smdk4412-common" remote="github" revision="cm-10.1"/&gt;
        &lt;project name="CyanogenMod/android_kernel_samsung_smdk4412" path="kernel/samsung/smdk4412" remote="github" revision="cm-10.1"/&gt;
        &lt;project name="CyanogenMod/android_hardware_samsung" path="hardware/samsung" remote="github" revision="cm-10.1"/&gt;
    &lt;/manifest&gt;</pre>

Resync the repository to grab the latest sources etc for the i9305;

<pre>    repo sync</pre>

Note!  This will take a LONG time, and will download a lot of stuff!

At this point you will have an assembled source tree.  Now we need to set up the JDK and Android SDKs before we can build;

## Configure Java JDK

It's possible to build CM with OpenJDK, but it's recommended that you build with the Sun Java 1.6 JDK instead.  So we'll discuss how to do that.  NOTE - Doing this will change your default Java version to the Sun one instead of OpenJDK!

Download the latest Sun Java 1.6 JDK x64 ( [jdk-6u43-linux-x64.bin](http://www.oracle.com/technetwork/java/javase/downloads/jdk6downloads-1902814.html) ) and install;

<pre>    cd ~/Downloads
    chmod +x jdk-6u43-linux-x64.bin
    ./jdk-6u43-linux-x64.bin
    sudo mv jdk1.6.0_43 /usr/lib/jvm/jdk-6u43-linux-x64.bin</pre>

Configure Java alternatives;

<pre>    sudo update-alternatives --install /usr/bin/javac javac /usr/lib/jvm/jdk-6u43-linux-x64.bin/bin/javac 1
    sudo update-alternatives --install /usr/bin/java java /usr/lib/jvm/jdk-6u43-linux-x64.bin/bin/java 1
    sudo update-alternatives --install /usr/bin/javaws javaws /usr/lib/jvm/jdk-6u43-linux-x64.bin/bin/javaws 1
    sudo update-alternatives --install /usr/bin/javadoc javadoc /usr/lib/jvm/jdk-6u43-linux-x64.bin/bin/javadoc 1
    sudo update-alternatives --install /usr/bin/javah javah /usr/lib/jvm/jdk-6u43-linux-x64.bin/bin/javah 1
    sudo update-alternatives --install /usr/bin/javap javap /usr/lib/jvm/jdk-6u43-linux-x64.bin/bin/javap 1
    sudo update-alternatives --install /usr/bin/jar jar /usr/lib/jvm/jdk-6u43-linux-x64.bin/bin/jar 1</pre>

Set the default Java version for your system to that JDK

<pre>    sudo update-alternatives --config javac
    sudo update-alternatives --config java
    sudo update-alternatives --config javaws
    sudo update-alternatives --config javadoc
    sudo update-alternatives --config javah
    sudo update-alternatives --config javap
    sudo update-alternatives --config jar</pre>

Run 'java -version' and check that the version matches what you installed.

Check that all the alternatives symlinks point to the JDK you installed;

<pre>    ls -la /etc/alternatives/java* && ls -la /etc/alternatives/jar</pre>

## Extract proprietary files

Note, your phone will already have to be rooted in order to be able to do this.  This will extract the necessary vendor-specific proprietary files you will need to be able to build a working firmware.  If your phone isn't rooted, root it now.

Download the Android SDK ( [android-sdk_r21.1-linux.tgz](http://developer.android.com/sdk/index.html) ) and install;

<pre>    cd ~/Downloads
    mkdir ~/android
    tar -zxvf android-sdk_r21.1-linux.tgz
    mv android-sdk-linux ~/android/sdk
    PATH=~/android/sdk:~/android/sdk/platform-tools:~/android/sdk/tools:$PATH</pre>

Run the Android SDK Tools with 'android', then select both of these components and install them;

+ Android SDK Tools  
+ Android SDK Platform-tools  
+ Android 4.2.2 (API 17)  
- Deselect 'Intel x86 Atom System Image'  
- Deselect 'MIPS System Image'

Let it download.  This will probably take a while.

Enable USB Debugging mode on your phone, then plug it in. In order to enable this, go to Settings -> About Phone, then tap the Build number field seven times.  This will enable Developer Options.  In Settings, go to Developer Options, and turn on USB Debugging mode.

Now, collect the proprietary files from the phone.

<pre>    cd ~/cm10.1
    . build/envsetup.sh
    cd ~/cm10.1/device/samsung/i9305
    ./extract-files.sh</pre>

It may be necessary to manually copy out '/sbin/cbd' from your phone.  You can do this by SSH'ing out of your phone by running a terminal emulator (rooted!) on the phone and then running ssh into your Ubuntu VM.  After that's all done, you can turn USB Debugging back off again.

Now fetch any prebuilts required for CM-10.1;

<pre>    ~/cm10.1/vendor/cm/get-prebuilts</pre>

At this point, you have a completed and ready source tree, and can now build your rom.

## Building the ROM

Rebuild like this (you do this the first time, and also do these steps subsequent times you want to update your build);

<pre>    PATH=~/bin:~/android/sdk:~/android/sdk/platform-tools:~/android/sdk/tools:$PATH
    cd ~/cm10.1
    repo sync
    . build/envsetup.sh
    brunch i9305</pre>

At the end, you should find a built ZIP file in ~/cm10.1/out/target/product/i9305 .

## What now?

Next up, you're going to have to get that onto your phone.  I'll write up soon about how to install ClockworkMod and get that newly compiled ROM into your phone.