---
title: 'Microk8s - Storage Configuration'
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

With Kubernetes, containers are considered to be transient.  But obviously there's a pretty strong need for being able to store permanent information.  This is where Persistent Volumes and Persistent Volume Claims come in.

# Dynamic Persistent Volumes with OpenEBS

In my case, I want to be able to deploy persistent volumes to my applications which are file-based, and mounted at a specific location.  So I've created a volume at `/srv/openebs/` and mounted it there, as the storage LV.

If you examine the storage classes already provided by OpenEBS out of the box, you should be able to figure out what to do next;

```
$ kubectl get sc
NAME                       PROVISIONER           RECLAIMPOLICY   VOLUMEBINDINGMODE      ALLOWVOLUMEEXPANSION   AGE
openebs-device             openebs.io/local      Delete          WaitForFirstConsumer   false                  65m
openebs-jiva-csi-default   jiva.csi.openebs.io   Delete          Immediate              true                   65m
openebs-hostpath           openebs.io/local      Delete          WaitForFirstConsumer   false                  65m

$ kubectl get sc/openebs-hostpath -o yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  annotations:
    cas.openebs.io/config: |
      - name: StorageType
        value: "hostpath"
      - name: BasePath
        value: /var/snap/microk8s/common/var/openebs/local
...
```

This leads us to a reasonably obvious storage class we can deploy, which we'll call `ssd-filebased` since it's an SSD volume and it's file based local storage;

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  annotations:
    cas.openebs.io/config: |
      - name: StorageType
        value: "hostpath"
      - name: BasePath
        value: /srv/openebs
    openebs.io/cas-type: local
  name: ssd-filebased
provisioner: openebs.io/local
reclaimPolicy: Retain
volumeBindingMode: WaitForFirstConsumer
```

Now if we deploy any storage using the `ssd-filebased` storage class, it'll automatically be provisioned in a unique directory under `/srv/openebs`.  A claim looks like this;

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: anexamplepvc-claim
spec:
  storageClassName: ssd-filebased
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 10Gi
```

That we have the `reclaimPolicy` set to Retain means that if we delete this PVC for some reason, the underlying volume won't be destroyed.  I usually prefer this mode, but you can set the policy to `Delete` if you're feeling brave.

Obviously with OpenEBS in the 'hostpath' mode your volume will only be on one node, and cannot be mounted on pods attempting to run on other nodes.  However, in my situation I only have one node, so that's fine.  If you have multiple nodes you need to use something like NFS.

# Local Folders via local-storage

There can also be a need to have specific local directories appear as persistent volumes.  The catch here is that Kubernetes isn't clever enough to figure out on which nodes the folder is available and only schedule the pod for those nodes.  So we have to customize that.  That's OK though.

First we'll create a local-storage storage class.  We use `WaitForFirstConsumer` mode so that it doesn't actually bind the volume until the first time it's used.

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: local-storage
provisioner: kubernetes.io/no-provisioner
volumeBindingMode: WaitForFirstConsumer
```

Then we'll create a persistent volume specifying the local path to use, and we'll also use a `nodeAffinity` rule so that the PV is only available on a specific node;

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-examplehostpath
  labels:
    type: local
spec:
  storageClassName: local-storage
  capacity:
    storage: 10Gi
  volumeMode: Filesystem
  accessModes:
    - ReadWriteMany
  persistentVolumeReclaimPolicy: Retain
  local:
    path: /srv/examplehostpath
  nodeAffinity:
    required:
      nodeSelectorTerms:
        - matchExpressions:
          - key: kubernetes.io/hostname
            operator: In
            values:
              - yourhostname
```

And then lastly we'll make a claim for that storage;

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: examplehostpath-storage
spec:
  storageClassName: local-storage
  accessModes:
    - ReadWriteMany
  volumeName: pv-examplehostpath
  resources:
    requests:
      storage: 10Gi
```

Note that there is a 1:1 mapping between PVs and PVCs, but there can be a n:1 mapping between pods and PVCs.  So this means if you have a directory you want accessible on many pods, you need one PV, one PVC, and then you access that PVC many times as required.  This can complicate things if you want the same underlying volume shared across multiple namespaces.  Your choice there are to either share the PVC across namespaces (which you can do), or if it's actually hostpath and `ReadWriteMany`, you can just simply duplicate the PersistentVolume definition and rely on the underlying filesystem to sort out locks.  I would not recommend doing that with a `ReadWriteOnce` volume, since Kubernetes won't be able to manage the Once criteria properly.

With that done, we now have two ways to provision persistent storage to pods.