---
id: 12
title: MKV Video Conversion with AVIDEMUX
date: 2012-12-29T08:48:00+09:30
author: James Young
layout: post
guid: http://wordpress/wordpress/?p=12
permalink: /2012/12/mkv-video-conversion-with-avidemux/
blogger_blog:
  - coding.zencoffee.org
blogger_author:
  - James Young
blogger_permalink:
  - /2012/12/mkv-video-conversion-with-avidemux.html
categories:
  - Computers
tags:
  - htpc
---
I've been spending way too much time today engaging in epic battle with [Avidemux](http://fixounet.free.fr/avidemux/) (a good tool, although I'm pretty angry at it right now) trying to get it to convert videos into a specific format, from the command line.  Anyway, I finally figured it out.

What I wanted was to get it to do the conversion from the command line so I can run it in a batch fashion.  I wanted the output video to be _exactly_ X264 AVC (which is MPEG4 Part 10 I believe), with AC3 audio, and in an MKV container.  This format is required so that it will work with _everything_ I have, ie;

  * MediaPortal
  * XBMC
  * Windows Media Player
  * VideoRedo

[VideoRedo](http://www.videoredo.com/en/index.htm) is unbelievably fussy about what it will accept, and only the above combination seems to work with everything. Well, straight MPEG-2 works as well, but that's huge.

You'd think that doing the above would be easy.  Anyway, it's really not.  But now I've nutted it out, it will be in the future...

Create a new file, named makemkv.py .  Put this somewhere you can get at.  The contents are;

<pre>#PY  #--automatically built--

adm = Avidemux()
adm.videoCodec("x264", "general.params=CQ=10", "general.threads=99", "general.fast_first_pass=True", "level=31", "vui.sar_height=1", "vui.sar_width=1", "MaxRefFrames=2", "MinIdr=100", "MaxIdr=500", "i_scenecut_threshold=40", "MaxBFrame=2", "i_bframe_adaptive=0", "i_bframe_bias=0", "i_bframe_pyramid=0", "b_deblocking_filter=False", "i_deblocking_filter_alphac0=0", "i_deblocking_filter_beta=0", "cabac=True", "interlaced=False", "analyze.b_8x8=True", "analyze.b_i4x4=False" , "analyze.b_i8x8=False", "analyze.b_p8x8=False", "analyze.b_p16x16=False", "analyze.b_b16x16=False", "analyze.weighted_pred=0", "analyze.weighted_bipred=False", "analyze.direct_mv_pred=0", "analyze.chroma_offset=0", "analyze.me_method=0", "analyze.mv_range=16", "analyze.subpel_refine=7", "analyze.chroma_me=False", "analyze.mixed_references=False", "analyze.trellis=1", "analyze.psy_rd=0.000000", "analyze.psy_trellis=0.000000", "analyze.fast_pskip=True", "analyze.dct_decimate=False", "analyze.noise_reduction=0", "analyze.psy=True" , "analyze.intra_luma=21", "analyze.inter_luma=21", "ratecontrol.rc_method=0", "ratecontrol.qp_constant=0", "ratecontrol.qp_min=0", "ratecontrol.qp_max=0", "ratecontrol.qp_step=0", "ratecontrol.bitrate=0", "ratecontrol.vbv_max_bitrate=0", "ratecontrol.vbv_buffer_size=0", "ratecontrol.vbv_buffer_init=0", "ratecontrol.ip_factor=0.000000", "ratecontrol.pb_factor=0.000000", "ratecontrol.aq_mode=0", "ratecontrol.aq_strength=0.000000", "ratecontrol.mb_tree=False", "ratecontrol.lookahead=0")
adm.audioClearTracks()
adm.audioAddTrack(0)
adm.audioCodec(0, "Aften")
;adm.audioSetDrc(0, 0)
adm.audioSetShift(0, 0,0)
adm.setContainer("MKV", "forceDisplayWidth=False", "displayWidth=1280")</pre>

Now create a new Powershell script somewhere.  Replace the reference to makemkv.py and avidemux_cli.exe to point to the appropriate paths on your system;

<pre>#
# Converts a video file to the following format:
#
# Video Codec:  x264 AVC (MPEG4 Part 10)
# Audio Codec:  AC3
# Container: MKV
#

param(
  [string]$profile = "c:\util\makemkv.py",
  [string]$target
)

begin {
  if (! $target) {
    write-error "Fatal:  Must provide target folder!"
  }
}

process {
  $file = $_
  if ($_ -and $target) {
    $sourcename = $file.FullName
    $targetname = (Get-Item $target).FullName + "\" + $file.BaseName + ".mkv"
    c:\util\avidemux\avidemux_cli.exe --load "$sourcename" --run "$profile" --save "$targetname" --quit
  }
}

end { }</pre>

Now that's done, you can process a whole bunch of AVI's in the current folder to the folder D:\Scratch like this;

<pre>dir *.avi | makemkv.ps1 -target D:\Scratch</pre>

<div>
  And you're done.  Phew.
</div>