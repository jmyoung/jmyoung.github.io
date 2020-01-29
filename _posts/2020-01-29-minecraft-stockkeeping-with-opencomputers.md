---
title: Minecraft Stockkeeping with OpenComputers
author: James Young
date: 2020-01-29T10:30:00+09:30
layout: post
categories:
  - Gaming
tags:
  - lua
  - minecraft
---

I'm doing a fair bit of mucking about in Minecraft lately, specifically with [All The Mods 3 Remix](https://www.curseforge.com/minecraft/modpacks/all-the-mods-3-remix).  One thing that's a common problem in modded minecraft is maintaining stock of materials.

A common solution when using [Applied Energistics 2](https://ae-mod.info/) is to leverage ME Level Emitters to shut off autocrafters when you reach a specified stock level.  Another solution is to simply ram all your autocrafted products into limited storage units (like [Storage Drawers](https://www.curseforge.com/minecraft/mc-mods/storage-drawers)) so that they back up and can't product any more.  

Both of these have some problems.  Level Emitters burn AE2 channels, are complex, and take up significant space.  Storage Drawers can lead to tick lag when machines are backed up trying to unload contents, and is not suitable for all cases.

Enter [OpenComputers](https://www.curseforge.com/minecraft/mc-mods/opencomputers).  OC lets you set up computers in Minecraft which can do quite a lot of stuff.  In this case, I'm using it for automated stock management.

# OpenComputers Setup

You'll need an OC Computer with all its relevant subcomponents set up, which is beyond the scope of this discussion.  You shouldn't require any high tier components, but you will require a network card at minimum.  You will also require an [Adapter](https://ocdoc.cil.li/block:adapter), to link up to your AE2 network and a [Redstone I/O](https://ocdoc.cil.li/block:redstone_io) block (if you want your system to turn something on/off).

Place the Adapter against any part of your AE2 network, and it should link up.  I've put mine against a ME Controller.  Place the Redstone I/O in a position where it can turn on your production system (by turning _OFF_ the redstone signal).

# Production Setup

I've written this with an [Environmental Tech](https://www.curseforge.com/minecraft/mc-mods/environmental-tech) Void Ore Miner in mind.  In this setup, ore from the miner is random and you must take all ore in order for other ore to be produced.  All ore from the Miner goes into [Industrial Foregoing](https://www.curseforge.com/minecraft/mc-mods/industrial-foregoing) Black Hole Units.

From there, there are regular AE2 recipe patterns to process the ore on demand.  These go through a fairly complex [Mekanism](https://www.curseforge.com/minecraft/mc-mods/mekanism) ore processing setup, but that's out of scope for this.

Your Adapter should be connected to an AE2 network that can see the products of the production and the recipes themselves.

# Stock Management Script

Following is the actual autocrafter script.  Put this and the stock list into an OpenComputers computer and run it.

It will check your stock levels at the defined intervals.  If anything was crafted, it will poll every few seconds until those crafting jobs are completed, then check levels against after a shorter period.  The longer period is used when stock levels are full.

```lua
-- Stock Management Script
-- Adapted from https://oc.cil.li/topic/1426-ae2-level-auto-crafting/

local component = require("component")
local gpu = component.gpu

-- Import the stocklist
require("stocklist")

results = {}     -- Array that holds currently pending crafts

while true do
    needOres = false
    loopDelay = maxDelay

    -- Process crafting indexes
    for curIdx = 1, #items do
        curName = items[curIdx][1]
        curDamage = items[curIdx][2]
        curMinValue = items[curIdx][3]
        curMaxRequest = items[curIdx][4]

        -- io.write("Checking for " .. curMinValue .. " of " .. curName .. "\n")
        storedItem = meController.getItemsInNetwork({
            name = curName,
            damage = curDamage
            })

        -- Write status of item
        io.write("Network contains ")
        gpu.setForeground(0xCC24C0) -- Purple-ish
        io.write(storedItem[1].size)
        gpu.setForeground(0xFFFFFF) -- White
        io.write(" items with label ")
        gpu.setForeground(0x00FF00) -- Green
        io.write(storedItem[1].label .. "\n")
        gpu.setForeground(0xFFFFFF) -- White

        -- We need to craft some of this item
        if storedItem[1].size < curMinValue then
            delta = curMinValue - storedItem[1].size
            craftAmount = delta
            if delta > curMaxRequest then
                craftAmount = curMaxRequest
            end

            -- Write out status message
            io.write("  Need to craft ")
            gpu.setForeground(0xFF0000) -- Red
            io.write(delta)
            gpu.setForeground(0xFFFFFF) -- White
            io.write(", requesting ")
            gpu.setForeground(0xCC24C0) -- Purple-ish
            io.write(craftAmount .. "... ")
            gpu.setForeground(0xFFFFFF) -- White

            -- Retrieve a craftable recipe for this item
            craftables = meController.getCraftables({
                name = curName,
                damage = curDamage
                })
            if craftables.n >= 1 then
                -- Request some of these items
                cItem = craftables[1]
                retval = cItem.request(craftAmount)
                gpu.setForeground(0x00FF00) -- Green
                io.write("OK\n")
                gpu.setForeground(0xFFFFFF) -- White

                -- Flag that we made something, so turn back on the inputs
               table.insert(results,retval)
               needOres = true
            else
                -- Could not find a craftable for this item
                gpu.setForeground(0xFF0000) -- Red
                io.write("    Unable to locate craftable for " .. storedItem[1].name .. "\n")
                gpu.setForeground(0xFFFFFF) -- White
            end
        end
    end

    if needOres == true then
      -- We crafted stuff.  Turn off redstone and set a short delay
      if redstoneControl ~= nil then
        io.write("Setting redstone controller to 0.\n")
        redstoneControl.setOutput(redstoneControlSide,0)
      end
      loopDelay = minDelay
    else
      -- We didn't.  Wait longer.
      if redstoneControl ~= nil then
        io.write("Setting redstone controller to 15..\n")
        redstoneControl.setOutput(redstoneControlSide,15)
      end
      loopDelay = maxDelay
    end

    -- Wait for pending crafts to be done
    while #results > 0 do
      -- See if we can complete a craft
      for curIdx = 1, #results do
        curCraft = results[curIdx]
        if curCraft.isCanceled() or curCraft.isDone() then
          io.write("A craft was completed.\n")
          table.remove(results,curIdx)
          break
        else
          -- A short delay if we are waiting for crafts to finish
          io.write("A craft is pending, sleeping for 5 seconds...\n")
          os.sleep(5)
        end
      end
    end

    io.write("Sleeping for " .. loopDelay .. " seconds...\n\n")
    os.sleep(loopDelay)
end
```

# Stock List

This should be called `stocklist.lua` and placed in the same directory as the autocrafter.  This defines settings and the list of stock.  Set `redstoneControl` and `redstoneControlSide` to `nil` if you aren't using that feature.

You should set the stock craft size to something that is a fraction of the stock wanted figure, because it's quite likely to craft an extra block.  Don't set it to 1 or something, otherwise the system will burn a lot of crafting cpus and run poorly.

Each entry is composed of the itemid for the item, "damage", the number you want to keep in stock, and the max number to try and craft at once.  Damage in this context is a subid which is used by a lot of mods to differentiate between items without burning a lot of item ids.  You can see some examples below.

```lua
local component = require("component")

-- Set these to the relevant components or nil if missing
meController = component.proxy(component.me_controller.address)
redstoneControl = component.proxy(component.redstone.address)
redstoneControlSide = sides.up

-- Each element of the array is "item", "damage", "number wanted", "max craft size"
-- Damage value should be zero for base items

items = {
    { "tconstruct:ingots",                   0, 16384, 1024 }, -- Cobalt Ingot
    { "tconstruct:ingots",                   1, 16384, 1024 }, -- Ardite Ingot
    { "thermalfoundation:material",        128, 16384, 1024 }, -- Copper Ingot
    { "thermalfoundation:material",        130, 16384, 1024 }, -- Silver Ingot
}

minDelay = 30    -- Seconds between runs if something was crafted
maxDelay = 300   -- Seconds between runs if nothing was crafted
```

# Crafting Recipe Optimization

It helps with performance a lot if you configure your recipes to work in bulk.  So, if you have a recipe for Copper Ore to Copper Ingots, instead of doing say;

* 1 Copper Ore --> 3 Copper Ingot

It is much faster in AE2 to set up the recipe as something like;

* 64 Copper Ore --> 3x64 Copper Ingot

That way AE2 can then transfer 64 Copper Ore as a single transfer (and single crafting job) instead of as 64 seperate transfers.
