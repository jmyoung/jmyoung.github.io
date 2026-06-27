---
title: Astrophotography Software List - 2026
date: 2026-02-18T14:48:00+09:30
author: James Young
layout: post
categories:
  - Astrophotography
---

In my astrophotography journey over the last year and a half I've gone through quite a few different software options, but I've mostly settled on a specific stack of software that I use at different stages.  Some of these products are free, some are paid, but they work together well for what I want to be doing.  This is, of course, an evolving list.

# Pre-Acquisition

## [Stellarium](https://stellarium.org/)

Planetarium software for Windows, iOS and others.  You can program this in with the details of your telescope and camera and it can be used to show approximate framing.  The default sky surveys will give you a reasonable idea of what your framing will look like for DSOs, but if you want to see actual photography, you'll need to enable surveys.  The default TOAST survey (the DSS button) may produce useful results, but I usually fall back to one of these surveys depending on what I need and where in the sky the target is;

* **NSNS DR0.2: RGB Continuum** - A sky survey of the northern sky in RGB.  This is quite good if you can use it.
* **NSNS DR0.2: H-alpha and Continuum** - A northern sky survey with Hydrogen-alpha mapped onto the Red channel, and the G and B channels as they normally would be.  Shows up most emission nebula brighter than straight RGB.
* **NSNS DR0.2: H-alpha (8-bit)** - The northern sky in Hydrogen-alpha narrowband.
* **NSNS DR0.2: [SII] (8-bit)** - The northern sky in Sulfur-II narrowband.
* **NSNS DR0.2: [OIII] (8-bit)** - The northern sky in Oxygen-III narrowband.
* **DSS2 Red (F+R)** - An all-sky rendition in monochrome of the red part of the visible spectrum.  This tends to show up nebula and other features quite well.  I usually use this and the built-in DSS.

## [Telescopius](https://telescopius.com/)

This is a new thing that I've been looking at.  Basically this allows you to enter your location and other details of your equipment, and then it can present a list of targets that will be visible to you tonight (or for other nights) that you can review and check framing for, and look at other poeple's images of that target.  So far it seems pretty great.

One feature in particular I like is the ability to project how many hours a target will be above a set altitude throughout the year so you can plan out when targets will be in season for you to shoot.

## [UpTonight](https://github.com/mawinkler/uptonight)

This is a Docker container which generates charts and tables that can be either used separately or ingested by HomeAssistant to project weather conditions, moon separation and other values to suggest what targets will be visible tonight.  I use this pretty heavily with HomeAssistant to tell me whether it's a good idea to shoot on an upcoming night.

# Acquisition

## [ASCOM](https://ascom-standards.org/)

ASCOM is a connection middleware used to connect astronomy equipment to astronomy software.  This is basically required in most circumstances to make all these pieces work together.

## [NINA](https://nighttime-imaging.eu/)

The brains of the operation.  NINA is a dedicated astrophotography capture suite, and has all the tools I need to run captures.  With it, I use a fair few plugins, mostly for convenience, but some do warrant being specifically called out;

### Hocus Focus

Hocus Focus is a (significant!) improvement to the default autofocus algorithms in NINA, and I use this to get better results out of my EAF than without it.

### Target Scheduler

Target Scheduler is a plugin that you can program with your desired targets/mosaics, exposure plans and other details, and when you configure a sequence it can automatically pick the 'best' target to shoot next based on those parameters.  I use this extensively to plan out my shooting, it's excellent.

I typically use Stellarium/Telescopius to find targets, put them into the Sequencer as framing wizard targets, get them framed up, and then import them into Target Scheduler as targets to then shoot.

### Discord Alerts

I have my Target Scheduler sequence configured to send me Discord notifications telling me how shooting is going over the night, and I also have HomeAssistant critical alerts set up to wake me up if (God forbid) rain comes in and the telescope is out.

## [PHD2](https://openphdguiding.org/)

PHD2 is used for guiding - in combination with a secondary camera and mount control (I control the mount through USB and the ASCOM driver), it acts to stabilize the mount and greatly reduce periodic and other kinds of errors, improving the maximum length exposures you can take without star trailing.

I also do my polar alignment with PHD2, because being in the Southern Hemisphere it is very hard to find the Southern Celestial Pole.  I used to use NINA's Three Point Polar Alignment plugin, but I now use PHD2's Polar Drift Alignment to get close, and then use full Drift Alignment to get it as close as I can get.  It's worth taking the time to get polar alignment right, and realistically it only takes me 10-15 minutes to get done and within about 1-2 arcsec.

# Processing

I use quite an extensive quite of processing software, so I'll break this up into sections.  But first, I primarily use [PixInsight](https://pixinsight.com/) for processing, which is a paid product.  It's not cheap, but it is also excellent and I've gotten results from it I could never get before.  Since PixInsight is the centerpiece of my processing, I'll mostly be naming modules in PixInsight and other products as needed.

## Calibration and Stacking

I do my calibrations and stacking using the **WeightedBatchPreprocessing** script in PixInsight.  This has had a number of improvements in recent times where it's become pretty well a one-stop shop for me to stack images.  It's not the fastest stacker, and it can use large amounts of disk space for intermediate files, but I'm generally happy to just let it run and it produces reliable results for me that are fully integrated into the PixInsight ecosystem and workflow.

## Color Calibration and Gradient Removal

In most circumstances, I use PI's **SpectrophotometricFluxCalibration** and **SpectrophotometricColorCalibration** (SPFC/SPCC) tools to calibrate brightness and color in images.  I usually remove gradients with **MultiscaleGradientCorrection** if the target has MARS data available, otherwise I use **GradientCorrection**.

## Deconvolution and Denoise

I use the excellent [BlurXterminator](https://www.rc-astro.com/software/bxt/) third-party tool by RC Astro to deconvolve (sharpen) images while still in the linear stage.  This tool is seriously excellent and very easy to use.