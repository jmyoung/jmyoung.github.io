---
id: 1029
title: Darktable for Windows using Vagrant
date: 2017-11-20T14:34:29+09:30
author: James Young
layout: post
guid: https://blog.zencoffee.org/?p=1029
permalink: /2017/11/darktable-windows-using-vagrant/
categories:
  - Computers
  - Technical
tags:
  - cygwin
  - darktable
  - linux
  - vagrant
---
I have an [Olympus TG5](https://www.olympus.com.au/Products/Compact-Digital-Cameras/T-Series/TG-5/Overview) camera, which has RAW support for [Darktable](https://www.darktable.org/), but only in the very latest (currently unreleased!) 2.3.0 version.  Since I have Windows, I'll have to build Darktable directly from source to be able to manipulate it.  Here's how you can do that.

First, I assume you have [Cygwin/X](https://www.cygwin.com/) running.  You'll also need [Vagrant](https://www.vagrantup.com/) installed, along with [VirtualBox](https://www.virtualbox.org/).  With all that in place, doing the rest is pretty straightforward.  Create a folder, and throw this `Vagrantfile` into it;

<pre># -*- mode: ruby -*-
# vi: set ft=ruby :

VMBOX = "bento/ubuntu-16.04"
VMHOSTNAME = "darktable"
VMRAM = "1024"
VMCPU = 2

VAGRANT_COMMAND = ARGV[0]

Vagrant.configure("2") do |config|
  # Configure the hostname for the default machine
  config.vm.hostname = VMHOSTNAME

  # Configure the VirtualBox provider
  config.vm.provider "virtualbox" do |vb, override|
    # The default ubuntu/xenial64 image has issues with vbguest additions
    override.vm.box = VMBOX

    # 1gb RAM, 2 vCPU
    vb.memory = VMRAM
    vb.cpus = VMCPU

    # Configure vbguest auto update options
    override.vbguest.auto_update = false
    override.vbguest.no_install = false
    override.vbguest.no_remote = true
  end

  # Mount this folder as RW in the guest, use this for transferring between host and guest
  config.vm.synced_folder "shared", "/srv/shared", :mount_options =&gt; ["rw"]

  # Build the server from a provisioning script (which will build Darktable for us)
  config.vm.provision "shell", inline: &lt;&lt;-SHELL
    # Install essential and optional dependencies
    apt-get update
    apt-get install -y gcc g++ cmake intltool xsltproc libgtk-3-dev libxml2-utils libxml2-dev liblensfun-dev librsvg2-dev libsqlite3-dev libcurl4-gnutls-dev libjpeg-dev libtiff5-dev liblcms2-dev libjson-glib-dev libexiv2-dev libpugixml-dev
    apt-get install -y libgphoto2-dev libsoup2.4-dev libopenexr-dev libwebp-dev libflickcurl-dev libopenjpeg-dev libsecret-1-dev libgraphicsmagick1-dev libcolord-dev libcolord-gtk-dev libcups2-dev libsdl1.2-dev libsdl-image1.2-dev libgl1-mesa-dev libosmgpsmap-1.0-dev

    # Install usermanual and manpage dependencies
    apt-get install -y default-jdk gnome-doc-utils libsaxon-java fop imagemagick docbook-xml docbook-xsl
    apt-get install -y po4a

    # Install this for Cygwin/X to work properly
    apt-get install -y xauth

    # Pull the master repo
    git clone https://github.com/darktable-org/darktable.git
    cd darktable
    git checkout master

    # Pull the submodules
    git submodule init
    git submodule update

    # Build Darktable
    ./build.sh --prefix /opt/darktable

    # Build documentation
    cd build
    make darktable-usermanual
    make darktable-lua-api
    cd ..

    # Install Darktable
    cmake --build "/home/vagrant/darktable/build" --target install -- -j2

    # Copy documentation into shared area
    cp build/doc/usermanual/*.pdf /srv/shared/
  SHELL

  # This piece here is run when we use 'vagrant ssh' to configure the SSH client appropriately
  if VAGRANT_COMMAND == "ssh"
    config.ssh.forward_x11 = true
  end

end
</pre>

Make a shared folder in that folder, and `vagrant up` followed by `vagrant ssh`.

Assuming everything is configured correctly, you can then start Darktable with;

<pre>/opt/darktable/bin/darktable</pre>

And off you go.  You can add some more mounts into the VM as required to share your picture library or whatever with it so you can manipulate it with Darktable.