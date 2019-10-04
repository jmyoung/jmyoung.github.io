---
title: CPU and Device Shares in Libvirt
date: 2019-10-02T09:30:00+09:30
author: James Young
layout: post
categories:
  - Technical
tags:
  - linux
  - kvm
---

Continuing from last post, I've also been looking at applying CPU/disk shares and weighting to my various virtual machines to also help regulate load. This is in addition to the per-device IOPS limitations I talked about using `virsh blkdeviotune`.

## CPU Shares

The first way to limit CPU utilization for a VM is to restrict the number of cores it has.  However, you can also use shares.  A normal process has a priority of 1024, so if two processes require CPU, they will get even amounts of CPU if they have a share setting of 1024 (it's a bit more complex than that, but that'll do for now).  A share setting of 512 means it will receive a correspondingly smaller ratio of the available time.

So let's say we want to set a specific VM to have half the normal shares of everything else, make that immediately take effect and save it into the VM's config;

```
virsh schedinfo naughtyvm --config --live --set cpu_shares=512
```

This will manifest itself in the VM's xml definition as;

```
<cputune>
  <shares>512</shares>
</cputune>
```

In the `domain` section.

## Block Device Weighting

You can also assign a weight to the machine for block device I/O.  The default weight is 500, and smaller values mean that the VM has less weight (and therefore gets less of the available I/O under contention).

This will set a specific VM to have half the normal weight, make it immediate and save it;

```
virsh blkiotune naughtyvm --config --live --weight 250
```

This appears in the XML for the domain as;

```
<blkiotune>
  <weight>250</weight>
</blkiotune>
```

You can also attach (as discussed) specific limits to certain IO devices that the VM has.  This will configure that machine's `/dev/sdb` device to only be able to write 100 IO/s;

```
virsh blkdeviotune naughtyvm sdb --config --live --write-iops-sec 100
```

Note that this is IO/s as seen by the VM, which does not necessarily correlate exactly to IO/s as seen by the underlying hardware.

## Memory Tuning

There is also a `virsh memtune`, but I would fairly strongly recommend *against* trying to fool with this, leave it alone.  You control memory allocation through other ways, and attempting to set the tuning parameters will likely result in pain.  To quote directly from the [libvirt documentation](https://libvirt.org/formatdomain.html#elementsMemoryTuning);

> Users of QEMU and KVM are strongly advised not to set this limit as domain may get killed by the kernel if the guess is too low, and determining the memory needed for a process to run is an undecidable problem

Probably best if you don't mess with that, leave them all at unlimited and control memory use elsewhere.

## Results

Well, ideally when you apply this you really shouldn't notice anything different, except under contention the things that were making more important things suffer will likely make them suffer less.  Setting up shares and weights won't stop your hardware being under high load, but it should help distribute the available resources better.


