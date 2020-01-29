---
title: High Disk I/O Usage by a VM?
date: 2019-09-18T13:49:00+09:30
author: James Young
layout: post
categories:
  - Technical
tags:
  - kvm
  - linux
---

When I was trying to do some stuff on my home server this morning, I noticed that performance was absolutely awful.  A quick examination of the server with `top` revealed that the server was getting _wrecked_ by extremely high I/O wait.

Finding out what did that was a bit harder though.  My system uses LVM with four PVs, and most LVs are raid5.  Many of my VMs have bulk storage which is actually LVs on the system passed through as devices to the VM.  This means that a performance problem is kind of hard to find.  There's a lot of layers until you find a culprit.

## `sar` To The Rescue!

The `sysstats` package on CentOS provides the `sar` utility.  This collects system performance stats over time and makes them available for review.  So we look at the `sar` report for the server concerned (I've heavily trimmed this);

```
# sar -A -s 07:30:00 -e 07:50:00
Linux 3.10.0-957.10.1.el7.x86_64 (yourhostnamehere)         18/09/19        _x86_64_        (4 CPU)

07:30:01        CPU      %usr     %nice      %sys   %iowait    %steal      %irq     %soft    %guest    %gnice     %idle
07:40:01        all     16.56      0.09      4.72     34.15      0.00      0.00      0.47     13.07      0.00     30.94
...

...

07:30:01          tps      rtps      wtps   bread/s   bwrtn/s
07:40:01       768.90    313.25    455.66  15439.13  15220.43

...

07:30:01          DEV       tps  rd_sec/s  wr_sec/s  avgrq-sz  avgqu-sz     await     svctm     %util
07:40:01      dev8-48    171.60   3568.24   3576.99     41.64     33.63    195.94      4.74     81.39
07:40:01      dev8-64    195.64   3498.18   3652.10     36.55     18.64     95.27      3.22     62.92
07:40:01      dev8-32    172.46   3527.42   3634.54     41.53     29.83    172.90      4.35     75.01
07:40:01       dev8-0     58.22   1287.14    746.50     34.93      0.05      0.82      0.14      0.80
07:40:01      dev8-16    170.98   3558.16   3610.30     41.93     44.42    259.73      5.12     87.58
07:40:01    dev253-82    757.99   2822.54   3215.54      7.97    169.58    223.72      0.83     62.61
07:40:01    dev253-84    759.62   2812.69   3238.40      7.97    226.18    297.75      0.92     70.14
07:40:01    dev253-86    758.13   2783.04   3256.13      7.97    155.18    204.69      0.76     57.36
07:40:01    dev253-88    758.92   2748.56   3296.92      7.97     93.42    123.10      0.59     44.94
07:40:01    dev253-89    948.34   1855.32   7312.11      9.67   1682.32   1773.94      0.99     93.98
07:40:01    dev253-93     86.06    684.89      2.91      7.99      2.73     31.76      0.95      8.19
07:40:01    dev253-95     86.13    685.28      3.08      7.99      3.37     39.08      1.13      9.71
07:40:01    dev253-97     85.90    685.08      1.44      7.99      2.31     26.87      0.76      6.56
07:40:01    dev253-99     85.92    685.11      1.56      7.99      1.47     17.12      0.52      4.42

```

I've trimmed a lot of stuff out of there that wasn't of interest.  The notable things here are;

* I/O wait time was very high during the period of bad performance.
* There was a lot of I/O going on during that time
* Some devXXX-nn devices showed a high IOPS during that time, with a high queue size and average wait time.  This indicates bad performance.

So what happened.  How do we break this down into something readable and understandable?

## Mapping devXX-nn to /dev/sd devices

First let's try and find what the dev items map to. 

```
# ls -l /dev | grep 8,
crw-------. 1 root root    108,   0 Sep 13 14:53 ppp
brw-rw----. 1 root disk      8,   0 Sep 13 14:53 sda
brw-rw----. 1 root disk      8,   1 Sep 13 14:53 sda1
brw-rw----. 1 root disk      8,   2 Sep 13 14:53 sda2
brw-rw----. 1 root disk      8,  16 Sep 17 16:18 sdb
brw-rw----. 1 root disk      8,  32 Sep 17 16:18 sdc
brw-rw----. 1 root disk      8,  48 Sep 17 16:18 sdd
brw-rw----. 1 root disk      8,  64 Sep 17 16:18 sde
```

Right, we can see here that those dev items in the `sar` report correspond to disks on the system;

| SAR dev | /dev | Purpose |
| --- | --- | --- |
| dev8-0 |  /dev/sda | System SSD |
| dev8-16 | /dev/sdb | LVM PV |
| dev8-32 | /dev/sdc | LVM PV |
| dev8-48 | /dev/sdd | LVM PV |
| dev8-64 | /dev/sde | LVM PV |

Right, so that makes sense.  The four disks involved in the RAID set were being smashed pretty badly (they're SATA drives, so ~170 IOPS is a bit too much for them).  Since all four were pretty similar in load, that means we don't have a bad hotspot somewhere from a non-striped LV dominating a disk.

## Mapping devXX-nn devices to LVs

Looking up the list, we see some dev253 devices causing huge amounts of I/O.  Mapping those back to what LV they're associated with is a bit harder, but we can do this;

```
# dmsetup ls --tree | egrep "253:(82|84|86|88|89)"
vghdd-vmrdm_burp (253:89)
 ├─vghdd-vmrdm_burp_rimage_3 (253:88)
 ├─vghdd-vmrdm_burp_rimage_2 (253:86)
 ├─vghdd-vmrdm_burp_rimage_1 (253:84)
 ├─vghdd-vmrdm_burp_rimage_0 (253:82)
```

Right.  That corresponds to the four raid5 components of the RDM for one of my VMs.  That VM was really hitting its raw device, severely.  So we need to either figure out what happened, or put a stop to it.

## Interpreting the Results

Examining that report, we can see that the device for the actual LV is `253:89`.  How often is that LV responsible for high load?  Let's find out;

```
# sar -A | grep dev253-89
04:00:01    dev253-89    251.49   2013.94   1740.62     14.93    309.77   1231.64      1.18     29.63
07:30:01    dev253-89    467.89   4836.39   3092.73     16.95    626.65   1339.33      1.59     74.56
07:40:01    dev253-89    948.34   1855.32   7312.11      9.67   1682.32   1773.94      0.99     93.98
08:50:01    dev253-89   1101.79   5804.53   8358.25     12.85    431.62    391.72      0.22     24.23
```

This is heavily trimmed to only show things with high IOPS.  So it seems that this happens a fair bit, and given those numbers are excessive for the back-end storage, we need to do something about it.  

## KVM Disk I/O Throttling

For obvious reasons I can't make the system faster or better without spending a lot, so I'm instead going to have to throttle that VM from being able to smash the disks so much.

For reference, here's the XML fragment from the disk involved;

```xml
<disk type='block' device='disk'>
  <driver name='qemu' type='raw' io='threads' discard='unmap'/>
  <source dev='/dev/mapper/vghdd-vmrdm_burp'/>
  <target dev='sdb' bus='scsi'/>
  <address type='drive' controller='0' bus='0' target='0' unit='1'/>
</disk>
```

Well, firstly, I probably need to be using the `cache='writeback'` option, given my server has a UPS and the VM using the RDM has a journalled filesystem.  Oops.

So, we'll change those things.

```
# virsh blkdeviotune burp sdb --config --total-iops-sec 200
```

This makes the XML fragment above look like this;

```xml
<disk type='block' device='disk'>
  <driver name='qemu' type='raw' io='threads' cache='writeback' discard='unmap'/>
  <source dev='/dev/mapper/vghdd-vmrdm_burp'/>
  <target dev='sdb' bus='scsi'/>
  <iotune>
    <total_iops_sec>200</total_iops_sec>
  </iotune>
</disk>
```

In particular, I selected 200 IOPS because this allows that server to blow half the normal limit of a SATA disk, across all four disks (usually a SATA disk can handle about 100 IOPS before the wheels start smoking).

We'll then restart the VM and wait for it to settle.

## What now?

Well, in theory that should have fixed the problem.  But to really see I'll just have to wait and see if those regular huge I/O spikes re-appear.