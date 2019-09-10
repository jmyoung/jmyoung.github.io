---
id: 960
title: Ansible with Vagrant on Windows
date: 2016-08-26T14:35:05+09:30
author: James Young
layout: post
guid: https://blog.zencoffee.org/?p=960
permalink: /2016/08/ansible-vagrant-windows/
categories:
  - Technical
tags:
  - ansible
  - vagrant
---
Since I'm converting all my builds and other things to use [Ansible](https://www.ansible.com/), the idea of using Ansible to customize a [Vagrant](https://www.vagrantup.com/) box is very attractive.

I've chosen to use the [ansible-local](https://www.vagrantup.com/docs/provisioning/ansible_local.html) provisioner in this case, so that Ansible runs inside the Vagrant box.  I'll do an example later where this isn't the case.

Have a look at [this gist](https://gist.github.com/jmyoung/fb034677ad332da5809fed4698ce55dc) for some info about how to do this.  Or read on.

# Step 1 - the Vagrantfile

In a blank directory, edit a new `Vagrantfile`.  Make it look something like this;

<pre># -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
 # The default ubuntu/xenial64 image has issues with vbguest additions
 config.vm.box = "bento/ubuntu-16.04"

 # Set memory for the default VM
 config.vm.provider "virtualbox" do |vb|
   vb.memory = "1024"
 end

 # Configure vbguest auto update options
 config.vbguest.auto_update = false
 config.vbguest.no_install = false
 config.vbguest.no_remote = true

 # Configure the hostname for the default machine
 config.vm.hostname = "ansible-example"

 # Mount this folder as RO in the guest, since it contains secure stuff
 config.vm.synced_folder "vagrant", "/vagrant", :mount_options =&gt; ["ro"]

 # And finally run the Ansible local provisioner
 config.vm.provision "ansible_local" do |ansible|
   ansible.provisioning_path = "/vagrant/provisioning"
   ansible.inventory_path = "inventory"
   ansible.playbook = "playbook.yml"
   ansible.limit = "all"
 end

end</pre>

There's a few things going on here.  First up, we define the default box we're going to use, the memory allocated to it, our auto-update options and the hostname.

Next up is we define a synced folder that will appear in the Vagrant box.  There is a default, which is for the folder the `Vagrantfile` is in to appear as `/vagrant`.  However, this is **shared** on VirtualBox with R/W access, which means that the box can modify your original files (including its own Vagrantfile).  Not necessarily bad, but I don't like the idea of that very much.

Lastly, we define the Ansible provisioner.  This will simply run the playbook that's in the vagrant/provisioning subfolder of the Vagrantfile against all hosts.

# Step 2 - Create Playbook

Do the following to create the rest of the structure (from within the directory your `Vagrantfile` is in);

<pre>mkdir -p vagrant/provisioning</pre>

Now, you'll need to create an `ansible.cfg` in that directory, like this;

<pre>[defaults]
host_key_checking = no

[ssh_connection]
ssh_args = -o ControlMaster=auto -o ControlPersist=60s -o UserKnownHostsFile=/dev/null -o IdentitiesOnly=yes</pre>

The parameters are necessary to avoid Ansible having a freak-out about SSH keys and whatnot when deploying.  Of course, if you have just one host, you don't need to worry about it.

Next, you need an `inventory` spec;

<pre>ansible-example ansible_connection=local</pre>

This forces deployments against the machine we're deploying to use the `local` connection type.

And lastly, a really basic playbook to test it out;

<pre>---

- hosts: ansible-example
 tasks:
 - copy: content="IT WORKS!\n" dest=/home/vagrant/ansible_runs

...</pre>

# Step 3 - Run it!

Now we've set up the most basic structure, bring it up!

<pre><strong>$ vagrant up</strong>
Bringing machine 'default' up with 'virtualbox' provider...
==&gt; default: Importing base box 'bento/ubuntu-16.04'...
==&gt; default: Matching MAC address for NAT networking...
==&gt; default: Checking if box 'bento/ubuntu-16.04' is up to date...
==&gt; default: Setting the name of the VM: ansible-example_default_1472187535117_41803
==&gt; default: Clearing any previously set network interfaces...
==&gt; default: Preparing network interfaces based on configuration...
 default: Adapter 1: nat
==&gt; default: Forwarding ports...
 default: 22 (guest) =&gt; 2222 (host) (adapter 1)
==&gt; default: Running 'pre-boot' VM customizations...
==&gt; default: Booting VM...
==&gt; default: Waiting for machine to boot. This may take a few minutes...
 default: SSH address: 127.0.0.1:2222
 default: SSH username: vagrant
 default: SSH auth method: private key
 default:
 default: Vagrant insecure key detected. Vagrant will automatically replace
 default: this with a newly generated keypair for better security.
 default:
 default: Inserting generated public key within guest...
 default: Removing insecure key from the guest if it's present...
 default: Key inserted! Disconnecting and reconnecting using new SSH key...
==&gt; default: Machine booted and ready!
==&gt; default: Checking for guest additions in VM...
 default: The guest additions on this VM do not match the installed version of
 default: VirtualBox! In most cases this is fine, but in rare cases it can
 default: prevent things such as shared folders from working properly. If you see
 default: shared folder errors, please make sure the guest additions within the
 default: virtual machine match the version of VirtualBox you have installed on
 default: your host and reload your VM.
 default:
 default: Guest Additions Version: 5.0.26
 default: VirtualBox Version: 5.1
==&gt; default: Setting hostname...
==&gt; default: Mounting shared folders...
 default: /vagrant =&gt; C:/cygwin64/home/username/ansible-example/vagrant
==&gt; default: Running provisioner: ansible_local...
 default: Installing Ansible...
 default: Running ansible-playbook...

PLAY [ansible-example] ****************************************************************

TASK [setup] *******************************************************************
ok: [ansible-example]

TASK [copy] ********************************************************************
changed: [ansible-example]

PLAY RECAP *********************************************************************
ansible-example : ok=2 changed=1 unreachable=0 failed=0


<strong>$</strong></pre>

And to prove that the playbook actually, really, did run;

<pre><strong>$ vagrant ssh</strong>
Welcome to Ubuntu 16.04.1 LTS (GNU/Linux 4.4.0-31-generic x86_64)

 * Documentation: https://help.ubuntu.com
 * Management: https://landscape.canonical.com
 * Support: https://ubuntu.com/advantage
Last login: Fri Aug 26 05:01:58 2016 from 10.0.2.2
<strong>vagrant@ansible-example:~$ cat ansible_runs</strong>
IT WORKS!
<strong>vagrant@ansible-example:~$</strong></pre>

You can then re-run the playbook any time you like with `vagrant provision` .

The main catch with running Ansible like this is that it actually installs Ansible on the Vagrant box.  You can get around this by running Ansible on your Vagrant host.  More on this later.