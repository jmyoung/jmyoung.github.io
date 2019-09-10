---
id: 898
title: TRIM Support on KVM Virtual Machines
date: 2016-05-31T23:20:40+09:30
author: James Young
layout: post
guid: https://blog.zencoffee.org/?p=898
permalink: /2016/05/trim-support-kvm-virtual-machines/
categories:
  - Technical
tags:
  - kvm
---
Messing with KVM as a replacement for my Microserver setup at home.  With KVM, you can define a thin-provisioned VM image file (a qcow2 file), which is a sparse file on the filesystem.  You can then configure the guest O/S so that TRIM support works, and it can then unmap unused blocks by the guest FS and have those blocks get unmapped the whole way down the stack (released from the sparse file, and ultimately trimmed from the underlying SSD if there is one).

The best bit?  This works for Windows **and** Linux guests, in the same way.

First up, adjust your machine so that it uses SCSI for the QCOW files you want to enable TRIM support on.  This may require some fudging with Windows (more on this one later).

Then, edit the XML for your VM definition with "virsh edit DOMAINNAME".  Find the disk definition, and make the changes that are bolded here;

<pre>&lt;disk type='file' device='disk'&gt;
 &lt;driver name='qemu' type='qcow2' <strong>discard='unmap'</strong>/&gt;
 &lt;source file='/var/lib/libvirt/images/example.qcow2'/&gt;
 &lt;backingStore/&gt;
 &lt;target dev='sda' bus='scsi'/&gt;
 &lt;alias name='scsi0-0-0-0'/&gt;
 &lt;address type='drive' controller='0' bus='0' target='0' unit='0'/&gt;
 &lt;/disk&gt;</pre>

Also make sure that your SCSI controller is of type 'virtio-scsi';

<pre>&lt;controller type='scsi' index='0' <strong>model='virtio-scsi'</strong>&gt;
 &lt;alias name='scsi0'/&gt;
 &lt;address type='pci' domain='0x0000' bus='0x00' slot='0x05' function='0x0'/&gt;
 &lt;/controller&gt;</pre>

Notably, only SCSI is able to pass the commands necessary to support TRIM properly.  Boot your VM, and you should now be able to run **fstrim**, or on Windows **defrag** should show the drive as a thin provisioned volume that can be trimmed (for Windows versions that support TRIM).

Now, for Windows.  Assuming you have already installed all the drivers, the easiest way to ensure that the kernel is loading the SCSI driver when you go and change the type (which otherwise results in a blue screen), temporarily add a second, small disk using the type you're changing C drive to.  Change C drive and boot, and it should boot fine with that type.  You can then remove the small disk.

Good luck!