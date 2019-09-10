---
id: 119
title: Making a transform for any MSI installer
date: 2007-03-09T05:07:00+09:30
author: James Young
layout: post
guid: http://wordpress/wordpress/?p=119
permalink: /2007/03/making-a-transform-for-any-msi-installer/
blogger_blog:
  - coding.zencoffee.org
blogger_author:
  - DW
blogger_permalink:
  - /2007/03/making-transform-for-any-msi-installer.html
categories:
  - Technical
---
Many MSI installers will let you generate unattended installs, using command-line arguments, but they may not permit the use of a standard transforms (MST) file to make the unattended install. This is a major problem if you are attempting to deploy software via GPO, since you can't specify a command line.

There's a way around this, though. Go and get the [Windows 2003 SP1 Platform SDK](http://www.microsoft.com/downloads/details.aspx?FamilyId=A55B6B43-E24F-4EA3-A93E-40C0EC4F68E5&displaylang=en), and install [ORCA](http://msdn2.microsoft.com/en-us/library/aa370557.aspx) from it. The SDK is a big download, but c'est la vie.

Once you've got ORCA up and running, make a copy of the MSI file you're customizing (we'll call them install.msi and install-cust.msi). Then open up install-cust.msi in ORCA. You will see a VAST number of tables. Don't worry about them too much. Go find the Property table.

Editing the copied MSI

Now, when you use command-line arguments, what actually happens is the MSI inserts those into the Property table when it runs. So, let's say you needed to add a TARGETDIR=c:\ argument into the Property table. Go look for the TARGETDIR property, and if you find it, edit it. Otherwise add it by right-clicking on the right-hand pane and clicking Add Row. Enter the values as appropriate. When you're done, save and close ORCA.

Generating the transform MST

From a command prompt, get to a directory that has the two MSI's in the same location. What we'll run here is msitran.exe, a Microsoft tool that came with the SDK that generates an MST that's the diff of two MSI's.

Run the following command, and you'll get a transform named install.mst;

> "c:\program files\microsoft platform sdk\bin\msitran.exe" -g install.msi install-cust.msi install.mst

Voila! You now have an MST for your original MSI that incorporates the changes you wanted!

Manually running the MSI with the MST

In order to test deploy, you just run the following command. That runs the MSI, applies the MST you created, and does so in basic mode (which is what you'd typically use in an unattended install);

> msiexec /i install.msi TRANSFORMS=install.mst

Assuming that works fine, go ahead and deploy via your method of choice.