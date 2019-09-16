---
title: Podman with KVM - A Gotcha
date: 2019-09-16T19:12:00+09:30
author: James Young
layout: post
categories:
  - Technical
tags:
  - podman
  - kvm
---

I recently put [Podman](https://podman.io/) on my KVM hypervisor, so I had a way of running containers alongside full KVM virtual machines.  Anyway, I ran into quite the gotcha.  Sometimes the Podman container storage doesn't get unmounted fully when you destroy a container.  And I found out why.

It looks like if you start a KVM virtual machine _after_ you have provisioned a container, that KVM virtual machine holds the mount for the container storage locked in its `/proc/PID/mountinfo`, preventing the container overlay from being cleared properly.

The solution here is not exactly obvious, but you do this;

1. Try and `podman rm --storage CONTAINERID` for the container that's complaining.  You will see a (very long) volume ID listed in there.
2. Find a PID that has that locked with `grep VOLUMEID /proc/*/mountinfo` .  
3. That will likely correspond to one of your KVM virtual machines.  Check with `ps -ef | grep PID` .
4. Stop the VM with `virsh shutdown VMNAME`
5. Now you can try the `podman rm --storage` command above again and clear out the container.
6. Start your VM _before_ restarting the container.
7. Then start your container again.

Not exactly wonderful.  Hopefully a better solution can be found.