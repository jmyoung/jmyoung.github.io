---
id: 945
title: Deploying a Quickstart Template to Openshift (CLI)
date: 2016-07-29T11:53:24+09:30
author: James Young
layout: post
guid: https://blog.zencoffee.org/?p=945
permalink: /2016/07/deploying-quickstart-template-openshift-cli/
categories:
  - Technical
tags:
  - docker
  - linux
  - openshift
---
Repeating what we did in my previous post, we'll deploy the Django example project to OpenShift using the CLI to do it.  This is probably more attractive to many sysadmins.

You can install the client by downloading it from the [OpenShift Origin Github](https://github.com/openshift/origin/releases) repository.  Clients are available for Windows, Linux, and so-on.  I used the Windows client, and I'm running it under Cygwin.

First, log into your OpenShift setup;

<pre>oc login --insecure-skip-tls-verify=true https://os-master1.localdomain:8443</pre>

We disable TLS verify since our test OpenShift setup doesn't have proper SSL certificates yet.  Enter the credentials you use to get into OpenShift.

Next up, we'll create a new project, change into that project, then deploy the test Django example application into it.  Finally, we'll tail the build logs so we can see how it goes.

<pre>oc new-project test-project --display-name="Test Project" --description="Deployed from Command Line"
oc project test-project
oc new-app --template=django-example
oc logs -f bc/django-example</pre>

After that finishes, we can review the status of the deployment with `oc status`;

<pre>$ oc status
In project Test Project (test-project) on server https://os-master1.localdomain:8443

http://django-example-test-project.openshift.localdomain (svc/django-example)
 dc/django-example deploys istag/django-example:latest &lt;-
 bc/django-example builds https://github.com/openshift/django-ex.git with openshift/python:3.4
 deployment #1 deployed about a minute ago - 1 pod

View details with 'oc describe &lt;resource&gt;/&lt;name&gt;' or list everything with 'oc get all'.</pre>

Ok, looks great.  You can now connect to the URL above and you should see the Django application splash page.

Now that worked, we'll change back into the default project, display all the projects we have, and then delete that test project;

<pre>$ oc project default
Now using project "default" on server "https://os-master1.localdomain:8443".

$ oc get projects
NAME DISPLAY NAME STATUS
default Active
test-project Test Project Active

$ oc delete project test-project
project "test-project" deleted

$</pre>

Fantastic.  Setup works!