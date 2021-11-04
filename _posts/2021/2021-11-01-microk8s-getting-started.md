---
title: 'Microk8s - Getting Started'
author: James Young
layout: post
categories:
  - technical
tags:
  - kubernetes
  - microk8s
  - kvm
  - linux
---

After having used CentOS for quite some time on my home server, I finally decided I'd had enough and wanted to change over to Ubuntu 20.04 instead.  There were a few reasons for this - but critically because of the support drop for CentOS 8, and how far CentOS tends to run behind fast-moving projects like containerization.

I also decided at this time I'd work on changing over all my existing Podman container setups to using [Microk8s](https://microk8s.io/) - a [snap](https://en.wikipedia.org/wiki/Snap_(package_manager))-deployed optimized [Kubernetes](https://kubernetes.io/) distribution for Ubuntu.  But I had some pretty specific requirements;

* Must be able to do everything I currently do in Podman, including source routing traffic out alternate IPs
* Must be able to co-exist with Libvirt and KVM
* Configuration must use as little tweaking as possible and be easily repeated and under source control

Adventures were had.  Besides intially configuring the combination K8s node / KVM host with Ansible, I discovered a number of deficiencies with standard Linux bridges that eventually forced the use of [Open vSwitch](https://www.openvswitch.org/).  However now it's all working, I can go into what was done.

# Network Configuration

Configuration of the host is done via [Netplan](https://netplan.io/).  I won't provide the full YAML for my netplan config, but I'll outline what I'm doing and why, and the relevant fragments in case you want to do the same.

* My host has a single primary interface, on a `192.168.0.0/24` class-C private subnet.
* It also has a LACP pair for a secondary interface, which is a trunk port on my switch for a number of VLANs on other networks.
* I want to connect my Libvirt VMs to the LACP pair on specific VLANs _or_ the whole trunk, and I also want my k8s containers to be able to have secondary interfaces on that pair.
* Libvirt VMs on the OVS switch should be able to talk to / be talked to by the k8s containers and the physical network.

These requirements, after much fiddling lead us to this;

```yaml
# 01-netplan.yaml
network:
  version: 2
  renderer: networkd
  openvswitch:
    ports:
      - [ patch0-0, patch0-1 ]
  ethernets:
    enp3s0:                               # Console interface
      ### Trimmed for clarity, this is a normal interface and
      ### also the default gateway
    enp2s0f0:                             # Bond slave Port 0
      dhcp4: no
      dhcp6: no
      accept-ra: no
    enp2s0f1:                             # Bond slave Port 1
      dhcp4: no
      dhcp6: no
      accept-ra: no
  bonds:
    bond0:                                # Physical bond going out
      interfaces: [ enp2s0f0, enp2s0f1 ]
      openvswitch:
        lacp: passive
      dhcp4: no
      dhcp6: no
      accept-ra: no
  bridges:
    ovs0:                                 # Primary OVS switch on main bond
      interfaces: [ bond0, patch0-0 ]
      openvswitch:
        fail-mode: standalone
        mcast-snooping: true
      dhcp4: no
      dhcp6: no
      accept-ra: no
    ovs1:                                 # Subordinate OVS switch for host
      interfaces: [ patch0-1 ]
      openvswitch:
        fail-mode: standalone
        mcast-snooping: true
      dhcp4: no
      dhcp6: no
      accept-ra: no
  vlans:
    k8s-vlan1:                            # VLAN1 port for Multus in Microk8s
      id: 1
      link: ovs0
      dhcp4: no
      dhcp6: no
      accept-ra: no
    k8s-vlan6:                            # VLAN6 port for Multus in Microk8s
      id: 6
      link: ovs0
      dhcp4: no
      dhcp6: no
      accept-ra: no
    ovs1vlan1:                            # Interface for the hypervisor to have on the trunk
      id: 1
      link: ovs1
      dhcp4: no
      dhcp6: no
      accept-ra: yes
      addresses:
        - 192.168.0.111/32                # IP Alias for Hypervisor host
```

In addition to this, we also turn on two sysctls using Ansible;

```yaml
    - name: Set ARP restriction sysctls
      copy:
        content: |
          net.ipv4.conf.all.arp_ignore=1
          net.ipv4.conf.all.arp_announce=2
        dest: /etc/sysctl.d/20-arpconfig.conf
      notify:
        - reload sysctls
```

A few critical notes here.  Most interfaces disable dhcp4, dhcp6, and don't accept RAs.  This is to stop the hypervisor from having an IP on those interfaces, because they are used for other things and not the hypervisor's O/S itself.

The most notable exception is the console interface `enp3s0` itself, and the interface on the OVS switch for the hypervisor's OS to use, on `ovs1vlan1`.

In addition, we set the host so that it will only respond to ARP requests on the interface that actually has the IP that the ARP request comes in on.  This prevents some 'functionality' where you wind up with the 'wrong' interface responding to ARP.

What is `patch0-1` and `patch0-0`?  They are a virtual patch cable linking up two OVS switches.  In this case linking up `ovs0` and `ovs1`.  `ovs0` is connected to the LACP bond at `bond0` which provides its uplink into the physical switchling layer, and then `ovs1` is linked to `ovs0` via the virtual patch.

Why does `ovs1` exist?  OVS, when deployed via Netplan, only seems to allow _one_ 'fake bridge' interface using a specific VLAN on one switch.  Since I need _two_ interfaces on VLAN 1, I need two switches - one for the interface that k8s will use, and one for the interface that the host's OS will use.

Why do you need two interfaces?  K8s will (as I'll discuss soon) use `macvlan` in order to link container secondary interfaces into the OVS switch.  If you have an address on the host which is on the same interface as the macvlan secondary interfaces, you can't get traffic from the containers into the host, because it requires [hairpin mode](https://en.wikipedia.org/wiki/Hairpinning).  OVS provides functionality to enable hairpin mode, but I found this configuration works fine in all cases I can think of.  Traffic that is destined from `ovs1vlan1` to one of the containers on `k8s-vlan1` transits as you'd expect and it works.

So that's a lot of stuff.  What's the real low-down on what's going on?

* The physical host has a console port on interface `en3ps0`.
* The LACP pair at `bond0` goes to Open vSwitch.
* There are two interfaces for k8s to use on `ovs0`, corresponding to access ports for vlan 1 and 6.
* There is an additional interface for the host OS to use with an address on `ovs1vlan1`.


# Installing Microk8s

Theoretically, installing Microk8s is very simple.  Either have a separate LVM volume for `/var/snap` (I recommend this, but I didn't do that myself unfortunately), or have your `/var` large enough (ie, over 20Gb), and then;

```bash
apt-get install -y iscsid
systemctl enable iscsid
systemctl start iscsid
snap install microk8s --classic
```

And then, with luck, you are done.  You'll need iscsid for one of the microk8s components we'll go into shortly.  From there;

```bash
microk8s status --wait-ready
```

Will show you what's going on while you wait for components to be installed.

# Addons and Components

In my setup I have a number of requirements which dictate the Microk8s addons I'll need, namely;

* I need cluster-internal DNS
* I'd like the dashboard
* I need configurable persistent storage for my applications
* I want to be able to attach secondary interfaces on other networks to my applications
* I need an internal registry to hold custom images
* I want to be able to route specific HTTP routes through to containers based on their hostname / path

This leads to a number of prebuilt components required, and some Tweaking.

```bash
snap install microk8s --classic
microk8s enable dns:192.168.0.1,192.168.0.2             # CoreDNS
microk8s enable dashboard                               # Kubernetes Dashboard
microk8s enable openebs                                 # Persistent storage
microk8s enable multus                                  # Multi-network capability
microk8s enable registry                                # Internal Registry on localhost:32000
microk8s enable ingress                                 # Ingress Controller
microk8s enable metallb:192.168.0.50-192.168.0.100      # MetalLB Load Balancer
microk8s status --wait-ready
```

The `dns` stanza enables CoreDNS functionality, using the specified upstream DNS servers (my internal DNS servers).  All the others should be self-evident from there what happens and what's being installed.  The `metallb` stanza configures MetalLB to automatically deploy load balancers within the specified range, 50-100.  You just pick a range out of your available IPs, you don't need them allocated on an interface - MetalLB will take care of that.

# A useful alias

Since we'll be doing a lot of work in namespaces, and doing `microk8s kubectl -n NAMESPACE` as root gets pretty frustrating, a useful alias comes to the fore.  First, install the kubectl snap and then set up the Administrative kubeconfig in your own user account instead of root.

```bash
mkdir -p ~/.kube
sudo snap install kubectl --classic
sudo microk8s config > ~/.kube/config
```

Then, put this alias into your `.bash_aliases`;

```bash
alias project='PROJECT=$(pwd | awk -F / "{ print \$NF }");kubectl -n $PROJECT'
```

Now, you can use `project` to automatically run kubectl commands in the namespace of whatever directory you're in.  This will become very useful shortly.

