---
id: 917
title: Shrinking a Linux VM in VMware Workstation
date: 2016-07-06T11:48:18+09:30
author: James Young
layout: post
guid: https://blog.zencoffee.org/?p=917
permalink: /2016/07/shrinking-linux-vm-vmware-workstation/
categories:
  - Technical
tags:
  - vmware
---
I do a fair bit of messing around with Linux in VMware Workstation on Windows.  This tends to make the underlying VMDK increase rapidly in size, and the 'Compact' feature doesn't work in the current version of Workstation.

Here's how to fix this.  You will need enough free space to hold the fully inflated VMDK twice.

In the VM, fill up the disk with a big file full of zeroes (I assume here you have slightly more than 10GB of disk space free);

<pre>dd if=/dev/zero of=/fillit bs=1M count=10240</pre>

Don't _completely_ fill the disk!  You just want to fill it enough that you'll get some benefit from the compact.  Get rid of the file afterwards.

Next, go and download the [VDDK](https://developercenter.vmware.com/web/sdk/60/vddk) from VMware.  Get a recent one, from the same (or newer) release of vSphere that corresponds to your Workstation install.  Extract it somewhere.

Now, find your VMDK.  You should find a single .vmdk followed by a whole bunch of -sNNN.vmdk files.  You want the head VMDK, it'll be a small file.

**Power off the VM, and discard any snapshots you may have of it!**

First up, defragment the VMDK;

<pre>C:\vddk\bin\vmware-vdiskmanager -d VMNAME.vmdk</pre>

Then, shrink it.

<pre>C:\vddk\bin\vmware-vdiskmanager -s VMNAME.vmdk</pre>

Done.  Your VMs should now consume a lot less space on disk!

**NOTE:  This won't work if you're encrypting the VMDK with dmcrypt or something, because the underlying sectors will just get random gibberish in them and you can't shrink that.  Regretfully, TRIM support doesn't work for Linux VMs in VMware because the SCSI emulation isn't the right version.**