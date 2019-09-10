---
id: 1079
title: Darktable on Windows through WSL
date: 2018-05-03T11:42:52+09:30
author: James Young
layout: post
guid: https://blog.zencoffee.org/?p=1079
permalink: /2018/05/darktable_windows_wsl/
categories:
  - Computers
tags:
  - linux
  - windows
---
<span style="color: #ff0000;"><strong>EDIT:  No longer required.  Since Darktable 2.4.0, there's an official native Windows installer for it.  Use that instead.  Easy!</strong></span>

With the [Windows Subsystem for Linux (WSL)](https://docs.microsoft.com/en-us/windows/wsl/install-win10) now being much more stable and useable, it turns out it's possible to install [Darktable](https://www.darktable.org/) on Windows with very little fuss.

This will require you to have Windows 10, and also to have at least the 1709 Fall Creator's Update (run `winver` and see your version, it should be 1709 or higher).

Follow the instructions [here](https://docs.microsoft.com/en-us/windows/wsl/install-win10) to install WSL, and then go ahead and install [Ubuntu](https://www.microsoft.com/en-us/store/p/ubuntu/9nblggh4msv6) from the Windows store.  Don't bother starting a prompt yet, we have more to do.

Next, you'll need an X server of some type, to display graphical UI from Ubuntu apps on the screen.  Unless you have something else, I suggest you install [VcXsrv](https://sourceforge.net/projects/vcxsrv/), it's straightforward to install and run.  When running this, just select all the defaults and go ahead.  This will give you an X server on `:0`, which we will use in a moment.

Now, start up Ubuntu, then type `nano ~/.profile` and press enter.  Enter the following text down the bottom,

<pre># set display
if [ "$DISPLAY" == "" ]; then
  export DISPLAY=localhost:0
  #export LIBGL_ALWAYS_INDIRECT=1
fi</pre>

Press Ctrl-O and Y in order to save.  Now exit that Ubuntu window and start it up again.  If you type `echo $DISPLAY` you should see the variable above printed out.  This tells programs in your Ubuntu window how to find your X server.

Next, go to [this PPA repository](https://launchpad.net/~pmjdebruijn/+archive/ubuntu/darktable-release), and install Darktable like this;

<pre id="yui_3_10_3_1_1525313387023_70" class="command subordinate">sudo add-apt-repository ppa:pmjdebruijn/darktable-release
sudo apt-get update
sudo apt-get install darktable</pre>

Wait a bit, and Darktable will be installed.  You can now run it by simply typing `darktable` into that prompt.

No mess, no fuss.  Enjoy.

&nbsp;