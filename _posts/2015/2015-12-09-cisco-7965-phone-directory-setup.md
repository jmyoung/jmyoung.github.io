---
id: 831
title: Cisco 7965 Phone Directory Setup
date: 2015-12-09T10:33:19+09:30
author: James Young
layout: post
guid: http://blog.zencoffee.org/?p=831
permalink: /2015/12/cisco-7965-phone-directory-setup/
categories:
  - Computers
  - Telephony
tags:
  - asterisk
  - c7965
  - voip
---
The Cisco 7965 has a Directory button, which can retrieve an XML document from a website and format that as a phone directory.  Setting it up is pretty simple.

In the SEPxxxx.cnf.xml for your phone, find the directoryURL tag and set that;

<pre>&lt;directoryURL&gt;http://intranet.example.com/directory.xml&lt;/directoryURL&gt;</pre>

Then, create that file on your web server.  An example appears below;

<pre>&lt;CiscoIPPhoneMenu&gt;
&lt;Title&gt;Home Directory&lt;/Title&gt;
&lt;Prompt&gt;Select a number&lt;/Prompt&gt;
&lt;MenuItem&gt;
 &lt;Name&gt;Extension-511&lt;/Name&gt;
 &lt;URL&gt;Dial:511&lt;/URL&gt;
&lt;/MenuItem&gt;
&lt;MenuItem&gt;
 &lt;Name&gt;Pizza Shop&lt;/Name&gt;
 &lt;URL&gt;Dial:55511123&lt;/URL&gt;
&lt;/MenuItem&gt;
&lt;/CiscoIPPhoneMenu&gt;</pre>

The items appear in the order they are listed.  I'm sure there's more cleverness you can do with the directory, but that should get you started.