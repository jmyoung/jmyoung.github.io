---
title: 'MetalLB and BGP'
author: James Young
layout: post
categories:
  - technical
tags:
  - kubernetes
  - microk8s
---

[MetalLB](https://metallb.org/) is a load balancer for Kubernetes that allows direct external IP ingress into Kubernetes clusters for access to pods and services.  Whereas a product like Multus adds interfaces to pods directly (thus giving them layer 2 access to that network), MetalLB implements the Kubernetes `LoadBalancer` kind, permitting services to be accessed directly from outside the cluster on their own IP addresses.

This is particularly important in a deployment which has more than one replica, since Multus would provision an interface per replica (and an IP per replica), which isn't terribly useful if you only want to have one endpoint to the replica set.

# Layer 2 Configuration

The default way to install MetalLB in microk8s is like this;

```bash
microk8s enable metallb:192.168.0.50-192.168.0.100
```

In this mode, it will create a default layer2 address pool for addresses between `192.168.0.50` and `192.168.0.100`.  What will now happen is that if you provision a `LoadBalancer`, MetalLB will pick an IP out of that pool and then when an ARP request arrives at an interface on your host for that IP, it will respond with the MAC of that interface, and receive the traffic and pass it on to the pod.

Sound great?  For setups where your node has simple networking - eg, a single interface, this will work well, and will probably do what you want.  For my setup, not so much.  I have multiple interfaces, some of which are components of a bond, others are OVS switches, and MetalLB responds on _all_ interfaces that receive the ARP request - even if a response on that interface would cause a hairpin issue or your host doesn't have an IP on that interface.

And as this [Github Issue](https://github.com/metallb/metallb/issues/277) shows, there's no immediate easy fix for this and you can't configure MetalLB to listen for ARP on only one particular interface.

Which brings us on to the other way to use MetalLB.

# BGP Configuration

In BGP mode, MetalLB will establish itself as a BGP neighbor with a router, and advertise routes for whatever IPs it is providing.  Your router will then handle sending the traffic through to whichever k8s node is hosting the load balanced IP.

You'll need a few pieces of information to be able to configure BGP;

* Administrative access to your router, and it needs to support BGP.
* An [AS number](https://en.wikipedia.org/wiki/Autonomous_system_%28Internet%29).  I recommend picking something in the defined ASN private range `64512 - 65534`.
* The IP address where MetalLB can peer to your router (that will probably be your default gateway).
* The IP address of your node which will peer to the router.
* The subnet that you're going to dedicate to MetalLB for declaring load balancers.

Obviously if your router is already set up with BGP and you know what you're doing, use your details instead and set it up. 

## Reconfiguring MetalLB

If you've already deployed MetalLB, you will have a `ConfigMap` named `config` which we will override;

```yaml
---
apiVersion: v1
data:
  config: |
    # Configured to use BGP to the core router
    # Private ASN range is 64512 - 65534
    peers:
      - peer-address: 192.168.0.254
        peer-asn: 64512
        my-asn: 64512
    address-pools:
      - name: default
        protocol: bgp
        addresses:
          - 192.168.10.0/24
        avoid-buggy-ips: true
      - name: layer2
        protocol: layer2
        addresses:
          - 192.168.0.50-192.168.0.100
        avoid-buggy-ips: true
kind: ConfigMap
metadata:
  name: config
...
```

You then apply that with;

```bash
kubectl -n metallb-system replace -f THEFILE.yaml
kubectl -n metallb-system rollout restart deployment/controller
kubectl -n metallb-system rollout restart deployment/speaker
```

What this does is define two address pools - a BGP pool (which is the default), and a layer 2 pool which is not.  I'm leaving the layer2 config in my setup even though it doesn't work properly so I have something to test with.

## Configuring the Router

If you're using pfSense, you're in luck.  For other routers, you'll have to follow whatever process is defined for that router.  I haven't set up BGP communities or anything like that, but considering my router only has exactly one BGP neighbor, I don't need to at this time.

First you will need to install the [FRR package for pfSense](https://docs.netgate.com/pfsense/en/latest/packages/frr/bgp/index.html).  Then, go into the config.  It's important that the AS number you enter for the router is the same ASN as you specified for MetalLB (we are using iBGP for internal use).  I also haven't figure out IPv6 yet.

* Services/FRR/BGP/BGP
  * BGP Router Options
    * Enable: Ticked
    * Local AS: 64512
    * Router ID: 192.168.0.254

* Services/FRR/BGP/Edit/Neighbors
  * General Options
    * Name/Address: 192.168.0.111
    * Description: MetalLB K8S Node
  * Basic Options
    * Remote AS: 64512
    * Update Source: IPv4, LAN
    * Address Family: Ticked
  
* Services/FRR/Global Settings
  * General Options
    * Enable: Ticked
    * Default Router ID: 192.168.0.254
    * Master Password: SET
    * Encrypt Password: Ticked
    * Syslog Logging: Ticked (untick this when it's working)

* Services/FRR/Global Settings/Edit/Prefix Lists
  * General Options
    * IP Type: IPv4
    * Name: MetalLB_k8s
    * Description: MetalLB BGP Prefix for Microk8s
    * Prefix List Entries
      * Sequence: 1
      * Action: Permit
      * Network: 192.168.10.0/24
      * Minimum Prefix: 24
      * Maximum Prefix: 32

* Services/FRR/Global Settings/Edit/Route Maps
  * General Options
    * Name: MetalLB_k8s
    * Description: RouteMap for Microk8s
    * Action: Permit
    * Sequence: 1
  * Next Hop
    * Next Hop Action: Match Peer
    * Peer: 192.168.0.253
    * Prefix List: IPv4: MetalLB_k8s
  * Source Protocol
    * Match Source Protocol: BGP

Now there's a lot of stuff going on there.  I'll break it down into a the key sections;

1. Configure the local BGP daemon to use a known ASN and identify itself correctly.
2. Define a prefix list so that the neighbor we add can only send prefixes in that range for security.  We also specify the minimum and maximum prefix (MetalLB will usually send /32's).
3. Add our k8s node as a peer for IPv4 routes.
4. Configure a route map including that prefix list and the peer, and an allow rule permitting the route to be inserted if it matches the prefix list.

With all of that done, you should see your BGP neighbor show up in the status in pfSense.  So let's now define a load balancer!

# Defining a Load Balancer

We'll do a quick example, one that just takes an address from the pool.  Assume you already have an app sitting around named 'web' which is listening on port 80 on a cluster IP, and you want it to be available outside the cluster.

Define the load balancer service like this;

```yaml
---
apiVersion: v1
kind: Service
metadata:
  name: test-lb
spec:
  type: LoadBalancer
  ports:
    - name: "80"
      port: 80
      targetPort: 80
  selector:
    app: web
...
```

And then, when you view your services, you should see something like this;

```
$ project get svc
NAME      TYPE           CLUSTER-IP       EXTERNAL-IP     PORT(S)        AGE
test-lb   LoadBalancer   10.152.182.18    192.168.10.1   80:30533/TCP   6s
```

The ExternalIP part is the critical part here.  If you try `curl http://192.168.10.1/` you should then see your web container's content.

As an aside, if you go into pfSense and look at your BGP status, you should also see this;

```
BGP table version is 19, local router ID is 192.168.0.254, vrf id 0
Default local pref 100, local AS 64512
Status codes:  s suppressed, d damped, h history, * valid, > best, = multipath,
               i internal, r RIB-failure, S Stale, R Removed
Nexthop codes: @NNN nexthop's vrf id, < announce-nh-self
Origin codes:  i - IGP, e - EGP, ? - incomplete

   Network          Next Hop            Metric LocPrf Weight Path
*>i192.168.10.1/32
                    192.168.0.111                   0      0 ?

Displayed  1 routes and 1 total paths
```

The really critical part there is the route.  `*>i192.168.10.1/32` is set to a nexthop of `192.168.0.111`.  That indicates the route is Valid, Best, and Internal, and a single IP route to our k8s node.  That's exactly what we wanted.

And so that's it.  There's other stuff you can do with specifying the IP you get instead of just taking one assigned from the pool, and specifying the load balancing policies and such, but that's for the next post.