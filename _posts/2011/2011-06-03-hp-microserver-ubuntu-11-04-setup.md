---
id: 83
title: 'HP Microserver &#8211; Ubuntu 11.04 Setup'
date: 2011-06-03T01:56:00+09:30
author: James Young
layout: post
guid: http://wordpress/wordpress/?p=83
permalink: /2011/06/hp-microserver-ubuntu-11-04-setup/
blogger_blog:
  - coding.zencoffee.org
blogger_author:
  - DW
blogger_permalink:
  - /2011/06/hp-microserver-ubuntu-1104-setup.html
categories:
  - Technical
tags:
  - linux
---
On Wednesday, I received my $199 (!!!) [HP Microserver](http://h10010.www1.hp.com/wwpc/au/en/sm/WF06b/15351-15351-4237916-4237917-4237917-4248009-5040202.html).  This little beauty is a low-cost, low-power solution for anyone who wants a tiny NAS or otherwise always-on box.

<table align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td>
      <a href="https://i2.wp.com/h10010.www1.hp.com/wwpc/images/emea/HP-ProLiant-MicroServer-series_190x170.jpg" imageanchor="1"><img border="0" src="https://i2.wp.com/h10010.www1.hp.com/wwpc/images/emea/HP-ProLiant-MicroServer-series_190x170.jpg?w=840" data-recalc-dims="1" /></a>
    </td>
  </tr>
  
  <tr>
    <td>
      HP Microserver with AMD N36L
    </td>
  </tr>
</table>

As standard, this unit comes with one 250Gb SATA disk drive, no DVD drive, 1Gb of PC3-10600 unbuffered ECC memory, and an AMD N36L processor.  It also comes equipped with all the drive chassis required to go up to 4 internal drives.  Memory can be upgraded to 2x4Gb of PC3-10600 in either ECC or non-ECC formats, unbuffered only.  I upgraded it straight away to 8Gb of RAM with two Kingston 4Gb unbuffered PC3-10600 CAS 9 DIMMs.

<a name="more"></a>

The N36L processor is the kind of processor usually found on netbooks or laptops - it's a dual-core 1.3GHz 64-bit processor, and even comes with AMD's VT-d hardware virtualization support.  The motherboard has an integrated onboard USB port, as well as the four USB ports on the front and two on the back.

So, what to do with this thing?  Well, I currently have a box that's running a compactflash card for storage, but it's a horrible CPU and has hardly any memory (256Mb).  As a result, it's slow.  But it uses very little power.  I want to make this as a replacement for that, which means power is at a premium.

As such, my plan was to run a *nix off of a USB key.  I also wanted a good filesystem so I could use the thing as a NAS when i get more physical drives.  I first toyed with the idea of [Oracle Solaris 11 Express](http://www.oracle.com/us/products/servers-storage/solaris/solaris-11-express-185123.html) running [ZFS](http://en.wikipedia.org/wiki/ZFS), but I abandoned that because I didn't like Solaris.

Then I had the idea of running [Ubuntu Server](http://www.ubuntu.com/business/server/overview) with ZFS from the [ZFS On Linux](http://zfsonlinux.org/) project.  That worked, but I locked up my Ubuntu 32-bit server install when I copied a file.  I then discovered that ZFS is _really_ memory hungry and you should use a 64-bit OS.  So I swapped to Ubuntu Server 64-bit.  It worked.  But then I found out that ZFS can't grow a stripe vertically, so if I upgraded to bigger drives I'd be in the poo.  Plus it's really a bit complex for what I want.

So what I wound out settling on was good old' MDADM with LVM and EXT4, running on Ubuntu Server 64-bit.

Next up was to install the O/S.  I have a 16Gb HP USB key sitting here, which is reasonably fast for something about 1cm longer than a USB plug.  Running hdparm gives me about 25 Mb/sec out of it, which is acceptable for this purpose.

Installation is straightforward, you basically follow the bouncing ball.  Pull out the 250Gb drive so nothing plays silly buggers, and when you get to the partitioning section you'll have to adjust things significantly.  I used guided partitioning with LVM, but then edited everything.  You'll need to recreate your swap to a more sane size (like 2Gb), and set your root to about 6gb.  I'd advise against just inflating the root to the size of the volume group, otherwise there's no point using LVM.  Keep the spare space in reserve.

Now, there's a few things to keep in mind with a USB key as your boot device.  You don't want to use a journalling filesystem, since it will kill the USB key in short order.  You also don't want to use the atime feature, since that will also kill the USB key.  So, change your root partition settings to use ext2 (non-journalling), and in options set the noatime flag.  Other options should be fine.

After installation, you should be able to boot up off the USB key into a working Ubuntu Server install.  There's a few other optimizations to be made.  Edit your /etc/fstab and add dirnoatime to the options for your root.  Then edit /etc/rc.local and add these commands;

> echo noop > /sys/block/<device>/queue/scheduler  
> echo 10 > /proc/sys/vm/swappiness

Be warned.  Your USB key will be the device letter of the _last_ drive you have in the system.  So if you have two physical drives plugged into the array and the USB key, the USB key will be /dev/sdc .   GRUB and /etc/fstab doesn't mind since they use UUID's, but the above commands do.  Just keep that in mind.

I'll write up some stuff about setting up MDADM when I get some drives to go in it.  But as it is, the Microserver looks like a pretty decent box for someone who wants a low power, lightweight storage box which can also do other stuff.