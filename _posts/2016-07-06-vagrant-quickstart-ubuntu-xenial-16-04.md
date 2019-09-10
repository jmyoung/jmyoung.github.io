---
id: 919
title: Vagrant Quickstart on Ubuntu Xenial 16.04 with Libvirt
date: 2016-07-06T12:10:53+09:30
author: James Young
layout: post
guid: https://blog.zencoffee.org/?p=919
permalink: /2016/07/vagrant-quickstart-ubuntu-xenial-16-04/
categories:
  - Technical
tags:
  - linux
  - ubuntu
  - vagrant
---
There's a few issues with running [Vagrant](https://www.vagrantup.com/docs/getting-started/) with Libvirt on Ubuntu 16.04 .  Namely, the bundled version of Vagrant is broken.  Whoops!

Here's how you can get it running using the upstream Vagrant (currently 1.8.4), get a basic libvirt running, and bring up a VM just to prove that it works (we'll use openSUSE because they provide a box that works with libvirt).

## Install the libvirt essentials

<pre>sudo apt-get update
sudo apt-get install ubuntu-virt-server ubuntu-virt-mgmt virt-manager libvirt-dev
sudo adduser YOURUSERNAME libvirtd</pre>

## Fetch and install upstream Vagrant

**DANGER:**  Don't run any vagrant plugins with sudo, it will probably trash permissions on your ~/.vagrant.d/ directory and go badly for you.

<pre>sudo apt purge vagrant
sudo apt autoremove
wget https://releases.hashicorp.com/vagrant/1.8.4/vagrant_1.8.4_x86_64.deb
sudo dpkg -i vagrant_1.8.4_x86_64.deb
sudo apt-get install -f
vagrant plugin install vagrant-libvirt</pre>

## Bring up a test VM

Showtime!  Bring up a test VM and connect to it with ssh...

<pre>mkdir testvm
cd testvm
vagrant init opensuse/openSUSE-42.1-x86_64
vagrant up --provider libvirt
vagrant ssh</pre>

## Get rid of the test machine

<pre>vagrant destroy</pre>

Phew.  Next up, making your own box.

##