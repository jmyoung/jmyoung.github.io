-- APIs

local component = require("component")
local tunnel = component.tunnel
local event = require("event")
local computer = require("computer")
local filesystem = require("filesystem")

-- Wireless Arguments

args = {...}

if (args[1] == nil) or (string.upper(args[1]) == "HELP") then
  print("Usage: wireless <mode> (on, off)")
  return
end

if (string.upper(args[1]) == "ON") then
  tunnel.send("wirelessOn")
  _, _, _, _, _, message = event.pull("modem_message")
  if message == "on" then
    local file1=io.open(".shrc","w")
    file1:write("/home/boot.lua")
    file1:close()
    local file2=io.open("bootVariable","w")
    file2:write("true")
    file2:close()
    if not filesystem.exists("/home/bootVariable") then
      local file3 = io.open("bootVariable","w")
      file3:write("")
      file3:close()
    end
    computer.shutdown(true)
  end

elseif (string.upper(args[1]) == "OFF") then
  io.write("Would you like to deactivate wireless mode? (Y/N) ")
  answer = string.upper(io.read())
  if answer == "Y" then
    print("Confirmed wireless mode deactivation. Please wait until the system reboots.")
    tunnel.send("wirelessOff")
    _, _, _, _, _, message = event.pull("modem_message")
    if message == "off" then
      local file1=io.open(".shrc","w")
      file1:write("")
      file1:close()
      local file2=io.open("bootVariable","w")
      file2:write("nil")
      file2:close()
      computer.shutdown(true)
    end
  elseif answer == "N" then
    print("Cancelling wireless mode deactivation. Rebooting system.")
    os.sleep(2)
    computer.shutdown(true)
  end
end
