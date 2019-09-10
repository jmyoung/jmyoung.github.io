---
id: 947
title: NFS Persistent Volumes with OpenShift
date: 2016-07-31T16:05:20+09:30
author: James Young
layout: post
guid: https://blog.zencoffee.org/?p=947
permalink: /2016/07/nfs-persistent-volumes-openshift/
categories:
  - Technical
tags:
  - docker
  - linux
  - openshift
---
[Official documentation here](https://docs.openshift.com/enterprise/3.1/install_config/persistent_storage/persistent_storage_nfs.html).  Following is a (very!) brief summary of how to get your Registry in Openshift working with an NFS backend.  I haven't been able yet to get it to deploy cleanly straight from the Ansible installer with NFS, but it is pretty straightforward to change it after initial deployment.

NOTE - A lot of this can probably be done in much, much better ways.  This is just how I managed to do it by bumbling around until I got it working.

# Creating the NFS Export

First up, you'll need to provision an NFS export on your NFS server, using the following options;

<pre>/srv/registry -rw,async,root_squash,no_wdelay,mp @openshift</pre>

Where '@openshift' is the name of a group in /etc/netgroup for all your OpenShift hosts.  I'm also assuming that it a mountpoint, hence 'mp'.

We then go to that directory and set it to be owned by root, gid is 5555 (example), and 0770 access.

# Creating the Persistent Volume

Now first, we need to add that as a persistent volume to OpenShift.  I assume it'll be 50Gb in size, and you want the data retained if the claim is released.  Create the following file and save as `nfs-pv.yml` somewhere you can get at it with the `oc` command.

<pre>---
 apiVersion: v1
 kind: PersistentVolume
 metadata:
   name: registry-volume
 spec:
   capacity:
     storage: 50Gi
   accessModes:
     - ReadWriteMany
   nfs:
     path: /srv/registry
     server: nfs.localdomain
   persistentVolumeReclaimPolicy: Retain
...</pre>

Right.  Now we change into the `default` project (where the Registry is located), and add that as a PV;

<pre>oc project default
oc create -f nfs-pv.yml
oc get pv</pre>

The last command should now show the new PV that you created.  Great.

# Creating the Persistent Volume Claim

Now you have the PV, but it's unclaimed by a project.  Let's fix that.  Create a new file, `nfs-claim.yml` where you can get at it.

<pre>---
 apiVersion: v1
 kind: PersistentVolumeClaim
 metadata:
   name: registry-storage
 spec:
   accessModes:
     - ReadWriteMany
   resources:
     requests:
       storage: 50Gi
...</pre>

Now we can add that claim;

<pre>oc project default
oc create -f nfs-claim.yml
oc get pvc</pre>

The last command should now show the new PVC that you created.

# Changing the Supplemental Group of the Deployment

Right.  Remember we assigned a GID of 5555 to the NFS export?  Now we need to assign that to the Registry deployment.

Unfortunately, I don't know how to do this with the CLI yet.  So hit the GUI, find the `docker-registry` deployment, and click Edit YAML under Actions.

In there, scroll down and look for the `securityContext` tag.  You'll want to change this as follows;

<pre>securityContext:
  supplementalGroups:
  - 5555</pre>

This sets the pods deployed with that deployment to have a supplemental group ID of 5555 attached to them.  Now they should get access to the NFS export when we attach it.

# Attaching the NFS Storage to the Deployment

Again, I don't know how to do this in the CLI, sorry.  Click Actions, then Attach Storage, and attach the claim you made.

Once that has finished deploying, you'll find you have the claim bound to the deployment, but it's not being used anywhere.  Click Actions, Edit YAML again, and then find the `volumes` section.  Edit that to;

<pre>volumes:
  -
    name: registry-storage
    persistentVolumeClaim:
      claimName: registry-storage</pre>

Phew.  Save it, wait for the deployment to be done.  Nearly there!

# Testing it out

Now, if you go into Pods, select the pod that's currently deployed for the Registry, you should be able to click Terminal, and then view the mounts.  You should see your NFS export there, and you should be able to touch files in there and see them on the NFS server.

Good luck!