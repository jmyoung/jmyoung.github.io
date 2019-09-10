---
id: 852
title: Caller ID Name Substitution with Asterisk
date: 2016-02-04T14:18:07+09:30
author: James Young
layout: post
guid: http://blog.zencoffee.org/?p=852
permalink: /2016/02/caller-id-name-substitution-asterisk/
categories:
  - Computers
  - Technical
  - Telephony
tags:
  - asterisk
---
There's only a pretty short list of numbers that I care about having Caller ID name substitution enabled for on my Asterisk setup, so I elected to use Asterisk's native database and some adjustments to my extensions to substitute in a name into the CALLERID(name) field.

First up, to insert number-to-name mappings, do this;

<pre>database put cidname 5551234 "John Smith"</pre>

For each number you want to be able to resolve numbers for.  If you then do

<pre>database show cidname</pre>

You'll then see the entries you've made.  Now, you need to adjust your dialplan.  Let's say that your incoming calls go to the Asterisk context "incoming-sip".  Change that context to "incoming-sip-cidlookup", and then create a new context like this;

<pre>[incoming-sip-cidlookup]
 exten =&gt; _X!,1,GotoIf(${DB_EXISTS(cidname/${CALLERID(num)})}?:nocidname)
 exten =&gt; _X!,n,Set(CALLERID(name)=${DB(cidname/${CALLERID(num)})})
 exten =&gt; _X!,n(nocidname),Goto(incoming-sip,${EXTEN},1)</pre>

What this does is pretty easy.  If an entry exists in the cidname database for the incoming call's callerid, then substitute the name field in that callerid for the name in the database.  Once this is done (or if no entry exists in the first place), then direct the call to the regular incoming-sip context.

For small numbers of mappings, this seems to work pretty well.  I'm looking at having an automated system that looks up incoming unknown caller IDs against a reverse phone lookup system.  More on that when I figure it out...