---
id: 839
title: Music-On-Hold for Asterisk
date: 2015-12-19T18:04:13+09:30
author: James Young
layout: post
guid: http://blog.zencoffee.org/?p=839
permalink: /2015/12/music-hold-asterisk/
categories:
  - Telephony
tags:
  - asterisk
  - voip
---
Got Music On Hold (MOH) working for Asterisk 1.8.  Turns out that it's not that hard, but there's some specific requirements to get it going if you don't want to use mpg123 or something.

First, you'll need some source music to use.  If you go to [Wikipedia](https://en.wikipedia.org/wiki/Wikipedia:Sound/list), you can find a whole bunch of OGG music that's free to use.  I grabbed something by Brahms.  I'd suggest you use stuff from there, that way you aren't license encumbered and at risk of getting sued by the RIAA hit squads.

Once you have that, you'll need to convert it to an 8000Hz, single-channel, OGG Vorbis sound file, by using [SoX](http://sox.sourceforge.net/) (available for Cygwin, which is what I did).  The command you'll need is;

<pre>sox input.ogg output.ogg channels 1 rate 8000</pre>

Asterisk is very fussy about the format, so it must be exactly like that.  Next up, fire up the Asterisk console (**asterisk -r**) and run the following;

<pre>core show file formats</pre>

Look through that and verify that **ogg_vorbis** is listed.  Next, we'll verify that Asterisk can actually transcode ogg to whatever codec your VOIP is using.  Run the following;

<pre>core show translation recalc 10</pre>

And verify that for the 'slin' row there is a number printed in the columns that correspond to the codecs that you're using (in my case, that's alaw, ulaw and g729).

Drop your ogg files into **/usr/share/asterisk/sounds/moh/** (in my case).  You will now need to put the following into musiconhold.conf to make it work;

<pre>[default]
mode=files
directory=/usr/share/asterisk/sounds/moh
sort=random</pre>

Your music-on-hold channel should be set to default anyway, so that should 'just work'.  If you want, you can create a fake extension in extensions.conf like this to test it;

<pre>exten = 444,1,Answer()
same = n,MusicOnHold()</pre>

Ringing that extension should result in hearing music.  Consult your Asterisk logs, common issues will be the OGG files not being in the exact format required.

Good luck.