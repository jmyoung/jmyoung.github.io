---
id: 902
title: Easy headless KVM deployment with virt-install
date: 2016-06-02T15:36:09+09:30
author: James Young
layout: post
guid: https://blog.zencoffee.org/?p=902
permalink: /2016/06/easy-headless-kvm-deployment-virt-install/
categories:
  - Technical
tags:
  - kvm
  - linux
---
I'd like for the VMs I'm deploying to be entirely headless (that is, no virtual graphics card at all, serial console only).  Turns out that you **can** do ISO-based installations of CentOS-7, headless, without having to unpack the ISO and mess with stuff.  Enter virt-install, the swiss army knife of KVM O/S installs;

<pre>virt-install \
 --name testvm \
 --ram 1024 \
 --disk size=10,bus=scsi,discard='unmap',format='qcow2' \
 --disk size=2,bus=scsi,discard='unmap',format='qcow2' \
 --disk size=2,bus=scsi,discard='unmap',format='qcow2' \
 --disk size=2,bus=scsi,discard='unmap',format='qcow2' \
 --disk size=2,bus=scsi,discard='unmap',format='qcow2' \
 --controller type=scsi,model=virtio-scsi \
 --vcpus 1 \
 --cpu host \
 --os-type linux \
 --os-variant centos7.0 \
 --network bridge=br0 \
 --graphics none \
 --console pty,target_type=serial \
 --location '/tmp/CentOS-7-x86_64-Minimal-1511.iso' \
 --extra-args 'console=ttyS0,115200n8 serial ks=http://192.168.1.10/centos.ks'</pre>

The above will deploy a brand-new KVM virtual machine, using the CentOS media it finds in /tmp, using the serial console.  It attaches it to the bridge br0, sets up five disks (all which support TRIM), and kickstarts it from the Kickstart answer file listed.  After install, you can get at the console with **virsh console testvm **.  And that's it.

You can use virt-install to install Windows 10 in the same way, but you'll need to attach the ISO images in a different way, like this;

<pre>virt-install \
 --name=windows10 \
 --ram=4096 \
 --cpu=host \
 --vcpus=2 \
 --os-type=windows \
 --os-variant=win8.1 \
 --disk size=40,bus=scsi,discard='unmap',format='qcow2' \
 --disk /tmp/Windows10Pro-x64.iso,device=cdrom,bus=ide \
 --disk /usr/share/virtio-win/virtio-win.iso,device=cdrom,bus=ide \
 --controller type=scsi,model=virtio-scsi \
 --network bridge=br0 \
 --graphics spice,listen=0.0.0.0 \
 --noautoconsole</pre>

This will attach the VirtIO driver disk on a second virtual CDROM device.  You'll need to use the GUI (note how Spice is configured to listen on all interfaces) to load the driver.  This configuration also supports TRIM.

You can also use the --location field to point it directly at a repository for installing stuff like Ubuntu straight from the 'net, eg;

<pre>--location 'http://mirror.aarnet.edu.au/ubuntu/dists/xenial/main/installer-amd64/'</pre>

Pretty cool stuff.