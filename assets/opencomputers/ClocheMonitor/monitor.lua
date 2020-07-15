-- Monitors a lot of redstone I/O modules
-- and outputs out the north side when the up side
-- is above a specified value
-- 
-- Used to toggle cloches

local setLevel = 10

local component = require("component")
local os = require("os")
local sides = require("sides")

while true do
  local sleepPeriod = 300

  for address in component.list("redstone", true) do
    local comp = component.proxy(address)
    local val = comp.getInput(sides.up)
    if val < setLevel then
      print("Component " .. address .. " has input " .. val .. " of " .. setLevel .. ", enabling cloche.")
      sleepPeriod=30
      comp.setOutput(sides.north,0)
    else
      comp.setOutput(sides.north,15)
    end
  end

  print("Sleeping for " .. sleepPeriod .. " seconds")
  os.sleep(sleepPeriod)
end