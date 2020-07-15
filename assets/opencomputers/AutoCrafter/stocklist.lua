-- 

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

    { "techreborn:ingot",                   23, 16384, 1024 }, -- Thorium Ingot

    { "mekanism:ingot",                      1, 16384, 1024 }, -- Osmium Ingot

    { "appliedenergistics2:material",        0, 16384, 1024 }, -- Certus Quartz
    { "appliedenergistics2:material",        1, 16384, 1024 }, -- Charged Certus Quartz

    { "bigreactors:ingotyellorium",          0, 16384, 1024 }, -- Yellorium Ingot
    { "draconicevolution:draconium_ingot",   0, 16384, 1024 }, -- Draconium Ingot
    { "libvulpes:productingot",             10, 16384, 1024 }, -- Iridium Ingot

    { "thermalfoundation:material",        895, 16384, 1024 }, -- Resonant Clathrate
    { "minecraft:redstone",                  0, 16384, 1024 }, -- Redstone Dust
    { "minecraft:diamond",                   0, 16384, 1024 }, -- Diamond
    { "minecraft:emerald",                   0, 16384, 1024 }, -- Emerald
    { "minecraft:coal",                      0, 16384, 1024 }, -- Coal
}

minDelay = 30    -- Seconds between runs if something was crafted
maxDelay = 300   -- Seconds between runs if nothing was crafted