---
id: 966
title: How to convert an MP4 to a DVD and burn it on Linux
date: 2016-08-27T16:48:42+09:30
author: James Young
layout: post
guid: https://blog.zencoffee.org/?p=966
permalink: /2016/08/convert-mp4-dvd-burn-linux/
categories:
  - Technical
format: aside
---
If you're using Vagrant with VirtualBox on Windows, create a new directory, throw the source mp4 in it, then create a `Vagrantfile` like this;

<pre>Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-16.04"

  config.vm.provider "virtualbox" do |vb|
  vb.customize ["storageattach", :id, "--storagectl", "IDE Controller", "--port", 0, "--device", 0, "--type", "dvddrive", "--passthrough", "on", "--medium", "host:X:"]
  end
end</pre>

Edit the `host:X:` to be the drive letter of your physical DVD drive.

Then bring up the VM with;

<pre>vagrant up
vagrant ssh
sudo -s -H</pre>

Now that's done, do this.  You can start from here if you're already on Linux or have some other means of getting a VM ready.  I assume you're going to want to make a PAL DVD, and that your DVD is in `/dev/sg0` (check with `wodim --devices`);

<pre>apt-get install dvdauthor mkisofs ffmpeg wodim
ffmpeg -i input.mp4 -target pal-dvd video.mpg
export VIDEO_FORMAT=PAL
dvdauthor -o dvd/ -t video.mpg
dvdauthor -o dvd/ -T
mkisofs -dvd-video -o dvd.iso dvd/
wodim -v dev=/dev/sg0 speed=8 -eject dvd.iso</pre>

All done.  Assuming everything went well, you have a freshly burned DVD, all using open source Linux software, with no horrible adware that tends to come with Windows DVD burning software.

You can then get rid of the VM with `vagrant destroy`.