---
title: High Disk I/O Usage - Part Two
date: 2019-09-20T16:50:00+09:30
author: James Young
layout: post
categories:
  - Technical
tags:
  - kvm
  - linux
---

In my last [post](/2019/09/high-disk-io-usage-by-a-vm/), I talked about how one of my KVM VMs was inflicting very high disk utilization on me.  However, there's some more things about this that has come to light.

## Use `iostat` for more information

Here's the essence of what the setup looks like;

<div class="mermaid">
graph TD;
  KVM[KVM Virtual Machine] --> LV[LV Device dm-89];
  LV --> dm82[LV Stripe dm82];
  LV --> dm84[LV Stripe dm82];
  LV --> dm86[LV Stripe dm82];
  LV --> dm88[LV Stripe dm82];
  dm82 --> sdb[SATA Disk sdb];
  dm84 --> sdc[SATA Disk sdc];
  dm86 --> sdd[SATA Disk sdd];
  dm88 --> sde[SATA Disk sde];
</div>


The `iostat` utility will show some fairly low level data, but it will show the average write size and other information, which turns out to be pretty important;

```
# iostat -x 5 sd{b,c,d,e}
Linux 3.10.0-957.10.1.el7.x86_64 (medusa.zencoffee.org)         19/09/19        _x86_64_        (4 CPU)

...

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           8.80    0.00    7.22   40.67    0.00   43.31

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdd            1521.00  2099.40   89.20   66.80  7244.80  9675.10   216.92     3.88   25.67   21.08   31.81   5.24  81.68
sde            1525.00  2097.40   85.40   63.80  7272.80  9249.50   221.48     1.45   10.30    6.96   14.78   2.95  43.94
sdc            1524.40  2106.40   87.20   64.40  7203.20  8822.30   211.42     2.18   14.27   11.38   18.18   3.51  53.18
sdb            1525.00  2107.00   81.60   65.60  7181.60  8835.50   217.62     3.61   24.37   21.98   27.33   5.16  75.96
```

We can see here that the disks are being hit quite hard - about 150 IOPS, with an average request queue size that's quite large.  That's OK, because when I took this log, I was doing an enormous `dd`, but at the time I was having the responsible VM writing a bunch of stuff to disk with;

```
dd if=/dev/urandom of=./test.out oflag=direct bs=4K count=262144 status=progress
```

This writes a whole bunch of stuff to that file (about 1Gb), bypassing any host caching.  What becomes interesting though is a better look at the `sar` output; 

```
# sar -A | egrep "dev253-(82|84|86|88|89)"
07:10:01          DEV       tps  rd_sec/s  wr_sec/s  avgrq-sz  avgqu-sz     await     svctm     %util
07:10:01    dev253-82    360.63   1739.05   1139.02      7.98     52.81    146.31      0.92     33.01
07:10:01    dev253-84    359.86   1725.34   1146.51      7.98     75.11    206.84      1.03     37.04
07:10:01    dev253-86    358.91   1724.10   1140.20      7.98     51.83    144.34      0.82     29.48
07:10:01    dev253-88    360.23   1715.21   1159.63      7.98     32.74     90.89      0.67     24.19
07:10:01    dev253-89    375.29   3496.57   2559.05     16.14    423.86   1107.75      1.56     58.64
```

So what we see here is that the requests hitting the dm-89 LV are 16k in size, but the requests hitting the disks (82,84,86,88) are ~8k average size.  This is very notable, because the RAID5 stripe size is 64k.

With RAID5, if you do a write that is less than the stripe size, there is a serious penalty involved, where the disk must read the old data, read the old parity, write the new data, recalculate the parity, and write the new parity.  So a write that is less than one stripe in size must necessarily cause two read IO and two write IO at minimum.

<div class="mermaid">
sequenceDiagram;
  participant Virtual Machine
  participant LV Volume
  participant RAID5 Stripes
  Virtual Machine->>LV Volume: Write a block < 64k
  RAID5 Stripes-->>LV Volume: Read the parity of the block
  RAID5 Stripes-->>LV Volume: Read the data in the block
  LV Volume-->>RAID5 Stripes: Write the parity back
  LV Volume->>RAID5 Stripes: Write the new data
</div>

This is quite clearly visible, because the LV (dev253-89) is only doing 375 IOPS, but that results in four times that amount on the underlying disks.

Now let's look at `sar` when I'm reading the LV;

```
14:20:01    dev253-82   1574.96  12599.70      0.00      8.00     34.92     22.17      0.40     62.86
14:20:01    dev253-84   1574.96  12599.70      0.00      8.00     24.37     15.48      0.28     44.04
14:20:01    dev253-86   1574.96  12599.70      0.00      8.00     15.60      9.90      0.18     28.41
14:20:01    dev253-88   1574.96  12599.70      0.00      8.00     11.74      7.45      0.14     21.94
14:20:01    dev253-89    393.74  50398.81      0.00    128.00      9.92     25.19      2.09     82.34
```

These reads are huge (4M each block size).  Note what's happening here - the LV is doing 393.74 IOPS with a 128k block size, and this is split up by the system into four 8k reads (8 * 4 = 64k).  Now, the 8k block size that the disks are being hit with is 16 times less than the 128k block size being requested by the LV, so you'd expect to see each disk have 4x the IOPs of the LV (there are four disks).  This matches up, we see the IOPS for the disks are 16 times higher than the LV.  But this doesn't correlate exactly to IO that actually hits the disks because of I/O coalescing.

So let's see how this correlates with `iostat`.

```
# iostat -x 5 dm-{89,82,84,86,88} sd{b,c,d,e} dm-{118,111,113,115,117}
Linux 3.10.0-957.10.1.el7.x86_64 (medusa.zencoffee.org)         19/09/19        _x86_64_        (4 CPU)

...

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
          11.37    0.00    4.74   32.16    0.00   51.73

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdd            1390.60  1791.20   72.60   64.00  6576.00  7355.50   203.98     4.54   33.06   28.29   38.47   7.05  96.36
sde            1396.00  1791.20   71.40   57.80  6577.60  7333.90   215.35     1.00    7.70    5.43   10.50   2.90  37.50
sdc            1396.60  1807.20   70.00   57.00  6574.40  7393.90   219.97     1.25    9.83    7.86   12.24   3.39  43.06
sdb            1398.20  1801.80   67.40   61.20  6571.20  7390.70   217.14     2.48   19.15   15.90   22.73   4.98  64.08
dm-82             0.00     0.00 1452.80    0.00  5811.20     0.00     8.00    47.22   32.59   32.59    0.00   0.57  82.42
dm-84             0.00     0.00 1452.80    0.00  5811.20     0.00     8.00    26.98   18.72   18.72    0.00   0.33  47.42
dm-86             0.00     0.00 1452.80    0.00  5811.20     0.00     8.00    14.23    9.79    9.79    0.00   0.17  25.28
dm-88             0.00     0.00 1452.80    0.00  5811.20     0.00     8.00    10.18    7.01    7.01    0.00   0.13  18.54
dm-89             0.00     0.00  363.20    0.00 23244.80     0.00   128.00    11.79   32.54   32.54    0.00   2.70  98.06
dm-111            0.00     0.00   11.80 1812.40   755.20  7249.60     8.78    99.32   54.45   21.71   54.66   0.43  77.92
dm-113            0.00     0.00   11.80 1812.40   755.20  7249.60     8.78    42.45   23.27    9.15   23.36   0.22  40.24
dm-115            0.00     0.00   11.80 1811.20   755.20  7244.80     8.78    24.98   13.70    3.31   13.77   0.09  15.80
dm-117            0.00     0.00   11.80 1811.20   755.20  7244.80     8.78    27.64   15.16    1.15   15.25   0.06  10.74
dm-118            0.00     0.00    0.00 3621.80     0.00 14487.20     8.00   146.69   40.70    0.00   40.70   0.28  99.98
```

Bit of revision about what's going on here.  Disks `sd{b,c,d,e}` are the actual PVs for the LV.  Disk `dm-89` is the LV that the VM is using, and `dm-{82,84,86,88}` are the components of the RAID5 LV.   Disk `dm-{118}` is the LV where I'm copying the original LV to, and `dm-{111,113,115,117}` are its components.

So, we can see here that the source LV (which is raid5) is doing 278 read IOPs, with an average size of 128k.  This is exploding into reads from all four disks, and is causing no RAID5 rewrite overhead (because it's just reading).  All good.

Now, `dm-118` and its four components are a raid10 volume which I'm dd'ing the whole raid5 volume to.  Note that it is _writing_ 7716 IOPS to the LV, but _reading_ virtually nothing.  And that multiplies to only 2x the IOPS on the disk end.  Note as well that the average request size on the LV end for `dm-118` is only 8k (which results in huge IOPS to get the performance), but because it's entirely sequential it gets coalesced before it hits the actual disks resulting in a huge disk IO size but manageable IOPs. 

`iostat` revealed fairly effectively that the LV-level IOPS does not necessarily correlate to IOPS that land on the actual disks, and the RAID5 rewrite penalty appears to have been hitting me very hard.  Probably especially badly because the workload is highly write intensive and not necessarily very sequential either (deduplicating backup system using a hardlinked filesystem).

## What about throttling?

So, throttling is not actually going to have the desired effect.  Sure, capping the VM at 200 IOPS will stop it from being able to dominate the disks, but the problem here is that this means 200 _LV-side_ IOPS, and if those IOPS are tiny and sequential it will still get capped even though those IOPS will be coalesced and have very little effect on the server.  So my choices seem to be to either cap it anyway and put up with it having awful random IO performance, and/or do something else.  Let's look at something else.

## RAID Type Choices

The real fix here seems to be to stop using RAID5 for this volume, and to review average write I/O sizes for other volumes as required and rework those too.  RAID10 does not suffer from the same parity rewrite penalty, and should offer much better performance under these circumstances.

<div class="mermaid">
sequenceDiagram;
  participant Virtual Machine
  participant LV Volume
  participant RAID0 Set
  participant RAID1 Set
  Virtual Machine->>LV Volume: Write a block < 64k
  LV Volume->>RAID0 Set: Write the new data
  RAID0 Set->>RAID1 Set: Write the new data
</div>

So this means that each write operation results in exactly two write IOPs, distributed across the disks.  There is a penalty in using more disk space overall though, but I've got the spare disk capacity.


## RAID10 Results

I did decide to transfer the entire volume to a raid10 LV through `dd`.  Immediately after the copy, the raid10 dm components were hit hard with high read IOPS because the copy sync was still happening.  After this finished, I was able to wait for the system to settle and re-run the test with throttling off.

```
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
          25.46    0.00   20.48   14.02    0.00   40.04

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdd               0.20  9058.60    1.60  114.00     7.20 34494.60   596.92     8.90   76.63  138.62   75.76   8.49  98.14
sde               0.80  8999.60    2.20  112.40    12.00 34280.20   598.47     5.43   46.66   48.45   46.62   6.13  70.20
sdc               0.80  9009.20    4.00  109.80    19.20 34305.80   603.25     5.26   45.94   58.00   45.50   5.73  65.22
sdb               0.80  9063.60    2.60  112.40    13.60 34508.20   600.38     7.35   63.63   32.00   64.36   6.88  79.08
dm-111            0.00     0.00    0.00 9142.40     0.00 36569.60     8.00   658.24   71.01    0.00   71.01   0.06  52.98
dm-113            0.00     0.00    0.20 9142.40     0.80 36569.60     8.00   519.54   55.84   72.00   55.84   0.05  41.48
dm-115            0.00     0.00    0.00 9084.80     0.00 36339.20     8.00   389.32   41.87    0.00   41.87   0.04  33.14
dm-117            0.00     0.00    0.00 9084.80     0.00 36339.20     8.00   393.46   42.30    0.00   42.30   0.04  34.18
dm-118            0.00     0.00    0.20 18841.60     0.80 75366.40     8.00  5574.11  281.88   72.00  281.88   0.05 100.00
```

That's what happened with the dd above (which did 50Mb/s throughput, much better than with RAID5).

Notably, 18k IOPS on the LV end turned into 9k IOPS per disk on the LV RAID10 component end, which then got coalesced into only ~110 IOPS on the SATA disk end (per disk).  Also note how the reads were basically zero during that time. That's pretty well in-line with expectations and much better than what was happening with RAID5.

## Final Take-Home

In the end the following lessons were learned;

* RAID5 partial stripe rewrite penalties are severe in this workload and punished the disks quite badly.
* The use of an LVM cache may actually help a large amount, this warrants further investigation.
* KVM IOPS limits apply to IOPS landing at the LV from the VM, and do not apply as you'd expect to the actual disks.
* I/O coalescing results in dramatically reduced I/O impact on the actual hardware compared to what the VM is trying to do.
* RAID10 results in significantly less write penalties for this workload.

## Postscript bonus!

I figured out this last night, it's horrible and no doubt an offense to the Gods, but it works.  It outputs the `iostat` output, but with the name of the relevant LV alongside it.  It also only outputs LVs that are in the VG named `vghdd`, change to suit.

```
# Assumes that the VG you want to look at is "vghdd"
DEV=`dmsetup ls --tree | grep ^vghdd | awk '{ print $2 }' | sed 's/.*://' | sed 's/)//' | sed 's/^/dm-/'`
FILTER=`mktemp`
dmsetup ls --tree | grep ^vghdd | sed 's/^vghdd-\(.*\) (\(.*\):\(.*\))/s\/\\\(dm-\3\.*\\\)\/\\1 \1\//' > $FILTER
iostat -x 5 sd{b,c,d,e} $DEV | sed -f $FILTER
```