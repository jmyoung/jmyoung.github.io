---
title: 'Proxmox and OpnSense Crashing'
author: James Young
layout: post
categories:
  - technical
tags:
  - proxmox
  - opnsense
  - kvm
  - protectli
---

If you happen to be using a [Protectli VP2420](https://protectli.com/product/vp2420/), equipped with a [Celeron J6412](https://ark.intel.com/content/www/us/en/ark/products/214758/intel-celeron-processor-j6412-1-5m-cache-up-to-2-60-ghz.html) CPU, and you're having random KVM virtual machine crashes when running [Proxmox](https://www.proxmox.com/en/), notably with crashes that produce an 'internal-error' message in Proxmox, have I got the post for you!

I've been running my [OPNsense](https://opnsense.org/) router for some time now, as a virtual machine.  Recently I got a Protectli box for running it, and I put Proxmox on it so I could run a few other components.  Randomly, particularly under high load, the router would either spontaneously reboot, or would crash with an 'internal-error' status in Proxmox.  Sometimes it would go on for a few days like that, sometimes it would crash half a dozen times in a day.  No amount of updating seemed to fix it.

On the Proxmox box, the following line was visible in `/var/log/syslog`;

```
Dec 31 12:49:30 proxmox QEMU[2043179]: KVM internal error. Suberror: 3
```

This error often breaks down to 'I had a hardware failure'.  So my first instinct was to blame the memory, and I got a new SODIMM.  This did not help.  What did help after a lot of digging around was a microcode update.  Unfortunately, in default install, Proxmox does not install microcode updates because they are closed-source binary packages.  There are some good reasons why this is the case, but I don't have any objections if I have closed-source binary blobs on my system, I just want things to work.

So here's how you can do that.

First, verify that you have a microcode version that is problematic (mine was `0x16`);

```bash
# this shows the current microcode version
cat /proc/cpuinfo | grep microcode

# this shows if it was updated by the kernel, and what the datestamp was
zgrep "microcode" /var/log/kern.log* | grep "updated early"
```

If this is the case, you'll need to enable the `contrib` and `non-free(-firmware)` repositories.  Run `cat /etc/sources.list`.  If you see `bullseye`, you will need to add the `non-free` repo, and if you see `bookworm` or later, you'll need the `non-free-firmware` repository.  Example appears below (edit with `nano` or your editor of choice);

```
# non-free-firmware required for microcode
deb http://ftp.au.debian.org/debian bookworm main contrib non-free-firmware
deb http://ftp.au.debian.org/debian bookworm-updates main contrib non-free-firmware
deb http://security.debian.org bookworm-security main contrib non-free-firmware
```

Once this is done, you will need to install the correct packages;

```
apt update
apt install -y intel-microcode
```

Then reboot the box.  After reboot, repeat the version check above, and your version should be `0x17` or higher.  If this is done, your crashing problems should (hopefully) be over.
