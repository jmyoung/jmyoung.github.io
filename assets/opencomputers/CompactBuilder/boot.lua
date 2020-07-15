-- APIs

local component = require("component")
local tunnel = component.tunnel
local event = require("event")
local computer = require("computer")
local gpu = component.gpu

-- Boot Variable

function getBootVariable()
  local file = io.open("bootVariable", "r")
  if file:read() == "true" then
    bootMode = true
  else
    bootMode = nil
    file:close()
  end
end

-- Visuals

function skipLine(number)
  for i=1, number do
    print("")
  end
end

function writeTitle()
  gpu.setForeground(0x6b7871)
  gpu.set(1, 1, "███████████████████████████████████████")
  gpu.set(1, 2, "█_|___|___|___|___|___|___|___|___|___█")
  gpu.set(1, 3, "█___|__██████╗███╗___███╗██████╗_|___|█")
  gpu.set(1, 4, "█_|___██╔════╝████╗ ████║╚════██╗_|___█")
  gpu.set(1, 5, "█___|_██║___|_██╔████╔██║ █████╔╝|___|█")
  gpu.set(1, 6, "█_|___██║_|___██║╚██╔╝██║ ╚═══██╗_|___█")
  gpu.set(1, 7, "█___|_╚██████╗██║_╚═╝_██║██████╔╝|___|█")
  gpu.set(1, 8, "█_|___|╚═════╝╚═╝_|___╚═╝╚═════╝__|___█")
  gpu.set(1, 9, "█___A Compact Machines 3 Autobuilder_|█")
  gpu.set(1, 10,"█_|___|___|___By: Samir___|___|___|___█")
  gpu.set(1, 11,"███████████████████████████████████████")
end

-- Start Program

function startProgram()
  os.execute("cls")
  gpu.setResolution(39, 17)
  writeTitle()
  skipLine(11)
end

getBootVariable()

if bootMode==true then
  startProgram()
end
