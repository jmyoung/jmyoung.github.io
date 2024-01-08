---
title: 'Watchdogs in KVM and Proxmox'
author: James Young
layout: post
categories:
  - technical
tags:
  - kvm
  - proxmox
---

Sometimes with virtual machines, it's necessary to have a watchdog timer that monitors the VM and automatically restarts it in the case of any serious problems such as hangs.  I have that need, and need such a configuration for both KVM and for Proxmox guests.  Fortunately this is easy to set up.

# Virtual Hardware Configuration

With the VM shut down, it's necessary to add the i6300esb watchdog timer to the machine.  This can be done with both hypervisors as follows;

KVM - Add the following fragment to the Devices section of your VM definition in `virsh edit`.  Pick a device slot that isn't in use;

```
<watchdog model='i6300esb' action='reset'>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x07' function='0x0'/>
</watchdog>
```

Proxmox - Edit the VM conf file in `/etc/pve/qemu-server` on your PVE box and append the following line;

```
watchdog: model=i6300esb,action=reset
```

After this is done, start the VM and jump into it.  I've done the following configuration with Ubuntu 20.04 and 22.04, it should work the same with most Linuxes.

# Install and Configure Watchdog

There are two parts where configuration needs to be changed.  The `i6300esb` driver is by default blacklisted, but that's OK, `watchdog` can load it anyway.  Edit `/etc/default/watchdog`, and set the following line;

```
watchdog_module="i6300esb"
```

Then, edit `/etc/watchdog.conf` and set the following parameters;

```
watchdog-device = /dev/watchdog
max-load-1 = 24
max-load-5 = 18
max-load-15 = 12
```

This configures the watchdog to use the correct device and also sets it up to trigger on very high load averages.  Adjust as required.  You can then arm the watchdog as follows;

```
systemctl enable watchdog
systemctl start watchdog
```

# Test Fire

Be warned that this test will (obviously) hard crash the box and result in a reboot if the watchdog has worked.  Enter the following;

```
sync
echo c > /proc/sysrq-trigger
```

If all has gone well, the VM should freeze, and a short time later should spontaneously reboot.  Excellent.

