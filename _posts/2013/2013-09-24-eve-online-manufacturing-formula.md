---
id: 680
title: 'EVE Online: Manufacturing Formula'
date: 2013-09-24T09:42:43+09:30
author: James Young
layout: post
guid: http://blog.zencoffee.org/?p=680
permalink: /2013/09/eve-online-manufacturing-formula/
categories:
  - Gaming
tags:
  - eveonline
  - gaming
---
I was working on fixing my manufacturing spreadsheets for [EVE Online](http://www.eveonline.com/) to make it a bit more automated.  And in order to do that, I needed to be able to calculate production time and material costs for blueprints straight from the raw BP data.  Anyway, it turns out that the formula at [EVEDev](http://wiki.eve-id.net/Equations) is close, but not quite right.  Following are the formulas that actually work.

# Time To Build

First, calculate the PTM modifier, which is usually going to just be your industry skill;

<img src="//s0.wp.com/latex.php?latex=%5Cdisplaystyle+PTM+%3D+%281-0.04+%2A+industrySkill%29+%2A+installationModifier+%2A+implantModifier&#038;bg=ffffff&#038;fg=000&#038;s=0" alt="&#92;displaystyle PTM = (1-0.04 * industrySkill) * installationModifier * implantModifier" title="&#92;displaystyle PTM = (1-0.04 * industrySkill) * installationModifier * implantModifier" class="latex" /> 

Then, run the following formula to determine the time (in seconds) to build one run of the BP.  Variables can be extracted from the EVE Database Dump.

## For PE >= 0

<img src="//s0.wp.com/latex.php?latex=%5Cdisplaystyle+time+%3D+baseProductionTime+%2B+%5Cfrac%7BproductivityModifier%7D%7B%281+%2B+peLevel%29%7D&#038;bg=ffffff&#038;fg=000&#038;s=0" alt="&#92;displaystyle time = baseProductionTime + &#92;frac{productivityModifier}{(1 + peLevel)}" title="&#92;displaystyle time = baseProductionTime + &#92;frac{productivityModifier}{(1 + peLevel)}" class="latex" /> 

## For PE < 0

<img src="//s0.wp.com/latex.php?latex=%5Cdisplaystyle+time+%3D+baseProductionTime+%2A+%281+-+%5Cfrac%7BproductivityModifier%7D%7BbaseProductionTime%7D+%2A+%28peLevel-2%29%29&#038;bg=ffffff&#038;fg=000&#038;s=0" alt="&#92;displaystyle time = baseProductionTime * (1 - &#92;frac{productivityModifier}{baseProductionTime} * (peLevel-2))" title="&#92;displaystyle time = baseProductionTime * (1 - &#92;frac{productivityModifier}{baseProductionTime} * (peLevel-2))" class="latex" /> 

# Required Materials

For each material required for a blueprint, there's the materialQuantity, which comes from the invTypeMaterials table for that BP (it's the quantity column).  This value is affected by ME research and skills.  Then there's the extra materials, which come from the ramTypeRequirements table for that BP.  Next, any materials in ramTypeRequirements which are marked as recyclable have their recycled materials (which you extract from looking them up in invTypeMaterials) subtracted from the list of materials required for the produced item.  The remaining materials from invTypeMaterials are then modified by skills and ME research as follows;

## For ME >= 0

<img src="//s0.wp.com/latex.php?latex=%5Cdisplaystyle+meWaste+%3D+ROUND%28%5Cfrac%7BmaterialQuantity+%2A+%28wasteFactor+%2F+100%29%7D%7BmeLevel+%2B+1%7D%29&#038;bg=ffffff&#038;fg=000&#038;s=0" alt="&#92;displaystyle meWaste = ROUND(&#92;frac{materialQuantity * (wasteFactor / 100)}{meLevel + 1})" title="&#92;displaystyle meWaste = ROUND(&#92;frac{materialQuantity * (wasteFactor / 100)}{meLevel + 1})" class="latex" /> 

## For ME < 0

<img src="//s0.wp.com/latex.php?latex=%5Cdisplaystyle+meWaste+%3D+ROUND%28%5Cfrac%7BmaterialQuantity+%2A+%28wasteFactor+%2F+100%29%7D%7B1+-+meLevel%7D%29&#038;bg=ffffff&#038;fg=000&#038;s=0" alt="&#92;displaystyle meWaste = ROUND(&#92;frac{materialQuantity * (wasteFactor / 100)}{1 - meLevel})" title="&#92;displaystyle meWaste = ROUND(&#92;frac{materialQuantity * (wasteFactor / 100)}{1 - meLevel})" class="latex" /> 

## Other Wastage

<img src="//s0.wp.com/latex.php?latex=%5Cdisplaystyle+skillWaste+%3D+ROUND%28%280.25+-+0.05+%2A+productionEfficiencySkill%29+%2A+materialQuantity%29&#038;bg=ffffff&#038;fg=000&#038;s=0" alt="&#92;displaystyle skillWaste = ROUND((0.25 - 0.05 * productionEfficiencySkill) * materialQuantity)" title="&#92;displaystyle skillWaste = ROUND((0.25 - 0.05 * productionEfficiencySkill) * materialQuantity)" class="latex" /> 

Installation wastage is likely calculated the same way, ie at 10% waste you'd multiply the materialQuantity by 0.10 to give the wastage.  But I haven't tested that, sorry.

## Total Material Required

<img src="//s0.wp.com/latex.php?latex=%5Cdisplaystyle+finalQuantity+%3D+materialQuantity+%2B+meWaste+%2B+skillWaste&#038;bg=ffffff&#038;fg=000&#038;s=0" alt="&#92;displaystyle finalQuantity = materialQuantity + meWaste + skillWaste" title="&#92;displaystyle finalQuantity = materialQuantity + meWaste + skillWaste" class="latex" /> 

And there you go.  Let me know if there's any errors.  The above formula work fine with all the stuff I'm building, which are a mix of various positive and negative ME and PE values.