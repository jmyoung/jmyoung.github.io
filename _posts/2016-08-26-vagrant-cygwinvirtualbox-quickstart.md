---
id: 958
title: Vagrant on Cygwin/Virtualbox Quickstart
date: 2016-08-26T10:28:10+09:30
author: James Young
layout: post
guid: https://blog.zencoffee.org/?p=958
permalink: /2016/08/vagrant-cygwinvirtualbox-quickstart/
categories:
  - Technical
tags:
  - vagrant
---
So, you want to try out [Vagrant](https://www.vagrantup.com/), and you're using Windows with Cygwin?  Have I got something for you!

# Preparing the Environment

Firstly, get [Oracle VirtualBox](https://www.virtualbox.org/) installed.  I personally prefer VMware Workstation, but VirtualBox works better for this.  Also get the extensions while you're at it.

Next, go and install Vagrant, and use the default settings.  Now we're going to have to manually patch a file in the Vagrant source.  Go to `/cygdrive/c/HashiCorp/Vagrant/embedded/gems/gems/vagrant-1.8.5/plugins/guests/linux/cap` in Cygwin, and edit `public_key.rb` .  At line 57, make the code look like the bit that's highlighted here;

<pre>if test -f ~/.ssh/authorized_keys; then
  grep -v -x -f '#{remote_path}' ~/.ssh/authorized_keys &gt; ~/.ssh/authorized_keys.tmp
  mv ~/.ssh/authorized_keys.tmp ~/.ssh/authorized_keys
  <strong><span style="color: #ff0000;">chmod 0600 ~/.ssh/authorized_keys</span></strong>
fi</pre>

This won't be necessary in a newer version of Vagrant, but it is required in 1.8.5 for some boxes to work.

Next up, bring up your Cygwin prompt, and do this.  This will remove the default VMware provider (if it's installed), and put in a plugin that automatically updates VirtualBox Guest Additions (optional, but very useful)

<pre>vagrant plugin uninstall vagrant-vmware-workstation
vagrant plugin install vagrant-vbguest
vagrant version</pre>

It should spit out that you're running an up-to-date Vagrant.  Great.

# Bringing up your first Vagrant box

Now, I'm a [CentOS](https://www.centos.org/) fan, so we'll be bringing up a CentOS box first.  From your Cygwin prompt, do this;

<pre>vagrant box add centos/7 --provider virtualbox
mkdir vagrant-test && cd vagrant-test
vagrant init centos/7
vagrant up
vagrant ssh</pre>

If everything's been done correctly, you'll find yourself in a shell on your new Vagrant box.  By default, the VM will be using NAT.  Poke around, and when done, exit and do;

<pre>vagrant destroy -f
cd ..
rm -rf vagrant-test</pre>

To clean everything up.  After cleanup, you'll still be left with the `centos/7` box cached, you can ditch that with `vagrant box remove centos/7` .

All done!  You've got a working Vagrant environment on Windows, running under Cygwin against a VirtualBox provider.  Magic!