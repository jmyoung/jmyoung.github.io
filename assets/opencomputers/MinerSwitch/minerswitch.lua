-- Void Miner Management Script

local component = require("component")
local sides = require("sides")

-- Set these to the relevant components or nil if missing
menetwork = component.proxy(component.me_interface.address)
redstoneControl = component.proxy(component.redstone.address)
redstoneControlSide = sides.east
local gpu = component.gpu

minDelay = 30       -- Seconds between runs if something was crafted
maxDelay = 300      -- Seconds between runs if nothing was crafted
minItems = 1000000   -- The minimum of an item allowed before turning on
minTypes = 62       -- The minimum number of types before turning on
onState = 0         -- The redstone setting when we turn on
offState = 15       -- The redstone setting when we turn off

minDelay = 30
maxDelay = 300

while true do
    local storedItem = menetwork.getItemsInNetwork()
    local turnedOn = 0

    -- Write number of items in network
    io.write("Network contains ")
    gpu.setForeground(0xCC24C0) -- Purple-ish
    io.write(#storedItem)
    gpu.setForeground(0xFFFFFF) -- White
    io.write(" types.\n")

    if #storedItem < minTypes then
      turnedOn = 1
    else
      for curIdx = 1, #storedItem do
        curName = storedItem[curIdx].label
        curSize = storedItem[curIdx].size

        if curSize < minItems then
          io.write("Network contains " .. curSize .. " units of " .. curName .. ".\n")
          turnedOn = 1
          break
        end
      end        
    end

   if turnedOn == 1 then
      io.write("  Setting system ")
      gpu.setForeground(0x00FF00) -- Green
      io.write("ON (")
      io.write(onState)
      io.write(")")
      gpu.setForeground(0xFFFFFF) -- White
      io.write("\n")
      redstoneControl.setOutput(redstoneControlSide,onState)
      io.write("Sleeping for " .. minDelay .. " seconds.\n")
      os.sleep(minDelay)     
   else
      io.write("  Setting system ")
      gpu.setForeground(0xFF0000) -- Red
      io.write("OFF (")
      io.write(offState)
      io.write(")")
      gpu.setForeground(0xFFFFFF) -- White
      io.write("\n")
      redstoneControl.setOutput(redstoneControlSide,offState)
      io.write("Sleeping for " .. maxDelay .. " seconds.\n")
      os.sleep(maxDelay)     
   end
 
end      