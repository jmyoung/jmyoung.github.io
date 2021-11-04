---
title: 'Microk8s - Multus Networking'
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

[Multus](https://github.com/k8snetworkplumbingwg/multus-cni) is a CNI plugin which allows containers to have additional interfaces added to them.  It supports using `macvlan` to add interfaces to ovs switches, and fits the need quite nicely.

Theoretically, you should be able to define a `NetworkAttachmentDefinition` for Multus to use in the `default` namespace and then attach it to other namespaces.  You can indeed do this with pooled networks using ranges, but you can't seem to do this when your IPAM method is `static`.

## Having a static secondary interface (which isn't the default route)

If you want to create a single, statically assigned secondary interface and add it to a pod, create your NetworkAttachmentDefinition (in your namespace);

```yaml
apiVersion: "k8s.cni.cncf.io/v1"
kind: NetworkAttachmentDefinition
metadata:
  name: vlan1-internal-static
spec:
  config: '{
    "cniVersion": "0.3.1",
    "name": "vlan1-internal-static",
    "plugins": [
      {
        "type": "macvlan",
        "master": "k8s-vlan1",
        "ipam": {
          "type": "static",
          "addresses": [
            { "address": "192.168.0.20/24", "gateway": "192.168.0.254" }
          ]
         }
      },
      {
        "type": "sbr"
      }
    ]
  }'
```

Then in your pod definition, you add something like this under metadata;

```yaml
metadata:
  annotations:
    k8s.v1.cni.cncf.io/networks: vlan1-internal-static
```

Now what happens is that when your pod comes up, it's also attached to the NAD named `vlan1-internal-static`.  Since that is defined as static and has exactly one possible address that can be used in it, your pod also gets address `192.168.0.20`.  This interface is created using `macvlan` on the OVS port named `k8s-vlan1`, which as we showed above is an access port on vlan 1.

We use the `sbr` plugin as well, so that source based routing is used.  This causes traffic destined for the 192.168.0.0/24 network to be directed out the Multus-created interface, but all other traffic goes out the regular Kubernetes-provided cluster interface.

## Having a static secondary interface (which is the default route)

Allowing the secondary interface to be the default gateway is more complex.  You'll need to allow the container to set its own IP through Capabilities when you create the NetworkAttachmentDefinition;

```yaml
apiVersion: "k8s.cni.cncf.io/v1"
kind: NetworkAttachmentDefinition
metadata:
  name: vlan1-internal-static
spec:
  config: '{
    "cniVersion": "0.3.1",
    "name": "vlan1-internal-static",
    "type": "macvlan",
    "master": "k8s-vlan1",
    "capabilities": { "ips": true },
    "ipam": {
      "type": "static"
    }
  }'
```

And then when you define your pod, you need to customize the network annotation to add detail about the IP the pod should use and specify the default route to your gateway;

```yaml
metadata:
    annotations:
      k8s.v1.cni.cncf.io/networks: '[{
        "name": "vlan1-internal-static",
        "ips": [ "192.168.0.20/24" ],
        "default-route": [ "192.168.0.254" ]
      }]'
```

This will cause all traffic not bound for an network that is local to the container to go out the `vlan1-internal-static` interface.

## Customizing DNS servers for a single pod

Under normal circumstances, a pod will resolve DNS agains the cluster's DNS servers.  This allows the pod to be able to resolve cluster-internal DNS entries.  Usually this is desirable, but under some circumstances you may want the pod to resolve against DNS servers directly, if for example you're directing some container's DNS down a VPN tunnel or something like that.  You can customize a pod to do this by modifying its spec like so;

```yaml
spec:
  dnsPolicy: "None"
  dnsConfig:
    nameservers:
      - 192.168.0.1
      - 192.168.0.2
    searches:
      - zencoffee.org
```

This fragment causes that pod to directly go to the mentioned nameservers for resolution and not use the cluster DNS servers.  And since the pod had an interface already on 192.168.0.0/24 with source based routing turned on, the DNS servers will see those requests come directly from the pod's Multus-allocated IP.

This does break the ability to resolve the internal cluster DNS entries like `service.cluster.local` or anything like that.

# Creating a global pool

You can also add a NetworkAttachmentDefinition to the `kube-system` namespace and it can be used by other namespaces.  

Create your pool in the required namespace with;

```yaml
apiVersion: "k8s.cni.cncf.io/v1"
kind: NetworkAttachmentDefinition
metadata:
  name: vlan1-internal-pool
  namespace: kube-system
spec:
  config: '{
    "cniVersion": "0.3.1",
    "name": "vlan1-internal-pool",

    "plugins": [
      {
        "type": "macvlan",
        "master": "k8s-vlan1",
        "ipam": {
          "type": "host-local",
          "ranges": [
            [
              {
                "subnet": "192.168.0.0/24",
                "rangeStart": "192.168.0.20",
                "rangeEnd": "192.168.0.49",
                "gateway": "192.168.0.254"
              }
            ]
          ]
        }
      },
      {
        "type": "sbr"
      }
    ]
  }'
```

Now what will happen here is that if you use this annotation;

```yaml
k8s.v1.cni.cncf.io/networks: "kube-system/vlan1-internal-pool"
```

Or this syntax instead;

```yaml
k8s.v1.cni.cncf.io/networks: '[{
  "name": "vlan1-internal-pool",
  "namespace": "kube-system"
}]'
```

Your pod will be automatically issued an IP from the pool you've created - it will get an address between `192.168.0.20` and `192.168.0.49`.  I haven't figured out how to override the default gateway when you use a pooled networkattachment like that, unfortunately.

# How about a test?!

Ok, we've been through a _lot_ of stuff just then.  Let's run through an example.  We'll assume you have the `kube-system/vlan1-internal-pool` network attachment created as above, and you don't want to override the default route.

```bash
cat <<EOF | kubectl create -f -
apiVersion: v1
kind: Pod
metadata:
  name: samplepod
  annotations:
    k8s.v1.cni.cncf.io/networks: "kube-system/vlan1-internal-pool"
spec:
  containers:
  - name: samplepod
    command: ["/bin/bash", "-c", "trap : TERM INT; sleep infinity & wait"]
    image: dougbtv/centos-network
EOF
```

This will create a pod in the default namespace named `pod/samplepod`, which will take an IP from the `vlan1-internal-pool` pool we defined above and add that as a secondary interface to it.  You can then ping that, or indeed whatever you may need to.  View how the deployment went with;

```bash
kubectl describe pod/samplepod
```

And then jump into it to look around with;

```bash
kubectl exec -it pod/samplepod -- bash
```
