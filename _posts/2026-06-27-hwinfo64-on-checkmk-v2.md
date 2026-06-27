---
title: 'Monitoring Windows Commodity Hardware Sensors in CheckMK with HWiNFO64'
date: 2026-06-27T11:51:00+10:30
author: James Young
layout: post
categories:
  - technical
tags:
  - checkmk
  - hwinfo64
  - monitoring
  - windows
---

I use [CheckMK](https://checkmk.com/) extensively at work, and I also run a small home lab with a few regular desktop Windows hosts.  Many years ago, I set up a CheckMK [HWiNFO64](https://www.hwinfo.com/) plugin to monitor the hardware sensors on those hosts, and this was fine, until the CheckMK v2 agent-based API came along.  The old plugin was written for the legacy CheckMK agent, and it was time to rewrite and improve it.

HWiNFO64 is a well-known hardware monitoring tool for Windows, and it has a feature called "Gadget Support" that writes all its sensor readings directly into the Windows registry under `HKCU\SOFTWARE\HWiNFO64\VSB`.  Crucially, it is not affected by the WinRing0 driver issue that plagues other solutions like OpenHardwareMonitor.  This still appears to be the best solution to this problem, given that it works just fine on standard commodity hardware, and it is free for personal use.

So, with the assistance of Claude, I rewrote the plugin to use the new agent-based API, and I also added some new features.  And it's also now available as a CheckMK MKP package, so you can install it easily on your own CheckMK server.

# How it works

A small Windows batch script runs as a CheckMK agent plugin.  It shells out to `reg query` to read the HWiNFO64 registry entries and outputs them in a format the CheckMK server can parse.  On the server side, a Python plugin (using the CheckMK v2 agent-based API) reads that output and classifies each sensor into one of four check types — temperatures, fans, percentages, and booleans — based on the label and value.

Each sensor becomes its own service in CheckMK, named after the HWiNFO64 label.  Thresholds are configurable per-service through WATO, so you can tune them to whatever makes sense for your hardware.  There's also Agent Bakery support, so you can deploy the agent plugin to Windows hosts automatically through CheckMK's usual mechanisms.  Agent Bakery of course requires Pro or higher editions of CheckMK, but the MKP itself can be installed into Community Edition and the agent plugin will still work if you deploy it manually.

# Getting it

The MKP is available on GitHub at [jmyoung/mkp-hwinfo64](https://github.com/jmyoung/mkp-hwinfo64).  The README covers requirements, build instructions, and installation steps.  You'll need CheckMK 2.4.0 or later, and HWiNFO64 configured with Gadget Support enabled on your Windows hosts.

It's pretty straightforward to set up — install HWiNFO64, enable the Gadget/registry reporting option, deploy the MKP, bake/deploy the agent, and your sensors should start showing up as services.  Configure your thresholds in WATO.  Done.

---