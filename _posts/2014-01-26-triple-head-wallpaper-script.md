---
id: 719
title: Triple-head Wallpaper Script
date: 2014-01-26T09:59:05+09:30
author: James Young
layout: post
guid: http://blog.zencoffee.org/?p=719
permalink: /2014/01/triple-head-wallpaper-script/
categories:
  - Technical
---
So, I have two computers with three monitors each - my home setup (3 x 2560x1440 monitors) and my work setup (3 x 1920x1200 monitors).  I want to have a collection of surround (ie, 16:3 aspect ratio) wallpapers and also to tile three regular 16:9 or 16:10 wallpapers so that one appears on each monitor.

My work pc also has an issue where a single full-screen wallpaper tiled shows the first pane on the second (middle) monitor, the second pane on the third (right) monitor, and the third pane on the first (left) monitor.

Enter [ImageMagick](http://www.imagemagick.org/script/index.php) and Powershell.  Let's assume you set up the following directory structure;

<pre>c:\wallpapers\tile     &lt;-- put one folder per tiled image desired
c:\wallpapers\fit      &lt;-- sort images however you want
c:\wallpapers\output   &lt;-- output images go here</pre>

For images that you want to be tiled, you should create one folder per output image you want in the tile folder, and then put at least three JPG/PNG images in those folders.  Three will be selected at random and tiled together.

Then, run the script that follows.  Technically, this script takes each image and runs one of two processes over it.  In tile mode, it resizes the image so that its smallest dimension fits on a single monitor (cropping from the edges evenly) and then tiles three of them together.  In fit mode, it resizes the image so that its smallest dimension fits on the triple-monitor surface, and if you're in ReorderPanes mode it then splits the image into three panes and reorders them.

<pre>Set-PSDebug -Strict

$WallpaperSource = "c:\wallpapers"
$WallpaperTarget = "c:\wallpapers\output"
$FileRegex = "(.jpg|.jpeg|.png)$"
$FullScreenSize = "7680x1440"
$SinglePaneSize = "2560x1440"
$ReorderPanes = $false

# Process all 'tile' images
Get-ChildItem "$WallpaperSource\tile" | Where-Object { $_.PSIsContainer -eq $true } | Foreach-Object {
	$sourcefolder = $_
	$targetfile = ($WallpaperTarget + "\tiled-" + $sourcefolder.BaseName + ".jpg")

	if (-not (Test-Path $targetfile)) {

		# Fetch 3 random images from the specified folder
		$sourcefiles = $sourcefolder | Get-ChildItem | Where-Object { $_.Name -Match $FileRegex } | Get-Random -Count 3

		if ($sourcefiles.count -eq 3) {
			# Convert the images
			write-output ("[" + $sourcefiles[0].Name + "] [" + $sourcefiles[1].Name + "] [" + $sourcefiles[2].Name + "] --> " + $targetfile)
			convert.exe `
				($sourceFiles[0].FullName) -resize "$SinglePaneSize^" -gravity center -extent "$SinglePaneSize" `
				($sourceFiles[1].FullName) -resize "$SinglePaneSize^" -gravity center -extent "$SinglePaneSize" `
				($sourceFiles[2].FullName) -resize "$SinglePaneSize^" -gravity center -extent "$SinglePaneSize" `
				+append $targetfile
	
		}

	}
}

# Process all 'Fit' images
Get-ChildItem -Recurse "$WallpaperSource\fit" | Where-Object { $_.Name -Match $FileRegex } | Foreach-Object {
	$source = $_
	$sourcefile = $source.FullName
	$targetfile = ($WallpaperTarget + "\fitted-" + $source.BaseName + ".jpg")

	if (-not (Test-Path $targetfile)) {

		# Convert the images
		write-output ($sourcefile + " --> " + $targetfile)
		if ($ReorderPanes) {
			convert.exe `
				$sourcefile -resize "$FullScreenSize^" -gravity center -extent "$FullScreenSize" -write mpr:orig +delete `
				mpr:orig -gravity center -extent "$SinglePaneSize" `
				mpr:orig -gravity east -extent "$SinglePaneSize" `
				mpr:orig -gravity west -extent "$SinglePaneSize" `
				+append $targetfile
		} else {
			convert.exe `
				$sourcefile -resize "$FullScreenSize^" -gravity center -extent "$FullScreenSize" `
				$targetfile
		}

	}
}</pre>

Notably, if you need to reconfigure the pane ordering you can adjust the bottom bit where ReorderPanes is set to true.  Otherwise just leave ReorderPanes set to false and you'll just get the resize/tile functionality.

From there, run the script and you will get a bunch of files in your output folder.  Set up Windows to point to that folder, on a short shuffle time, and use Tile mode.

Magic!