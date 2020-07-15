-- APIs

local component = require("component")
local tunnel = component.tunnel
local event = require("event")
local computer = require("computer")

-- Wall Confirmation Prompt

function promptWall()
  io.write("Insufficient amount of walls. Would you like to construct more now? (Y/N) ")
  answer = string.upper(io.read())
  if answer == "Y" then
    tunnel.send("Y")
    _, _, _, _, _, message = event.pull("modem_message")
    if message == "failed" then
      print("Operation failed. Not enough items.")
      os.sleep(2)
      computer.shutdown(true)
    elseif message == "success" then
      print("Confirmed operation. Constructing walls now.")
    end
  elseif answer == "N" then
    print("Operation denied. Cancelling machine wall construction.")
    tunnel.send("N")
    os.sleep(2)
    computer.shutdown(true)
  end
end

-- Crafting Arguments

args = {...}

if (args[1] == nil) or (string.upper(args[1]) == "HELP") then
  print("Usage: craft <item> (maxMachine, minMachine, walls, tunnel, redTunnel)")
  return
end

if (string.upper(args[1]) == "MAXMACHINE") then
  tunnel.send("maxMachine")
  _, _, _, _, _, message = event.pull("modem_message")
  if message == "wallConfirm" then
    promptWall()
  elseif message == "maxMachineConfirm" then
    io.write("Would you like to construct a maximum compact machine? (5x5x5) (Y/N) ")
    answer = string.upper(io.read())
    if answer == "Y" then
      tunnel.send("Y")
      _, _, _, _, _, message = event.pull("modem_message")
      if message == "failed" then
        print("Operation failed. Not enough items.")
        os.sleep(2)
        computer.shutdown(true)
      elseif message == "success" then
        print("Confirmed operation. Constructing compact machine now.")
      end
    elseif answer == "N" then
      print("Operation denied. Cancelling compact machine construction.")
      tunnel.send("N")
      os.sleep(2)
      computer.shutdown(true)
    end
  end
elseif (string.upper(args[1]) == "WALLS") then
  tunnel.send("walls")
  _, _, _, _, _, message = event.pull("modem_message")
  if message == "wallConfirm" then
    io.write("Would you like to construct sixteen machine walls? (Y/N) ")
    answer = string.upper(io.read())
    if answer == "Y" then
      tunnel.send("Y")
      _, _, _, _, _, message = event.pull("modem_message")
      if message == "failed" then
        print("Operation failed. Not enough items.")
        os.sleep(2)
        computer.shutdown(true)
      elseif message == "success" then
        print("Confirmed operation. Constructing machine walls now.")
      end
    elseif answer == "N" then
      print("Operation denied. Cancelling machine wall construction.")
      tunnel.send("N")
      os.sleep(2)
      computer.shutdown(true)
    end
  end
elseif (string.upper(args[1]) == "MINMACHINE") then
  tunnel.send("minMachine")
  _, _, _, _, _, message = event.pull("modem_message")
  if message == "wallConfirm" then
    promptWall()
  elseif message == "minMachineConfirm" then
    io.write("Would you like to construct a normal compact machine? (3x3x3) (Y/N) ")
    answer = string.upper(io.read())
    if answer == "Y" then
      tunnel.send("Y")
      _, _, _, _, _, message = event.pull("modem_message")
      if message == "failed" then
        print("Operation failed. Not enough items.")
        os.sleep(2)
        computer.shutdown(true)
      elseif message == "success" then
        print("Confirmed operation. Constructing compact machine now.")
      end
    elseif answer == "N" then
      print("Operation denied. Cancelling compact machine construction.")
      tunnel.send("N")
      os.sleep(2)
      computer.shutdown(true)
    end
  end
elseif (string.upper(args[1]) == "TUNNEL") then
  tunnel.send("tunnel")
  _, _, _, _, _, message = event.pull("modem_message")
  if message == "wallConfirm" then
    promptWall()
  elseif message == "tunnelConfirm" then
    io.write("Would you like to construct two tunnels? (Y/N) ")
    answer = string.upper(io.read())
    if answer == "Y" then
      tunnel.send("Y")
      _, _, _, _, _, message = event.pull("modem_message")
      if message == "failed" then
        print("Operation failed. Not enough items.")
        os.sleep(2)
        computer.shutdown(true)
      elseif message == "success" then
        print("Confirmed operation. Constructing tunnels now.")
      end
    elseif answer == "N" then
      print("Operation denied. Cancelling tunnel construction.")
      tunnel.send("N")
      os.sleep(2)
      computer.shutdown(true)
    end
  end
elseif (string.upper(args[1]) == "REDTUNNEL") then
  tunnel.send("redTunnel")
  _, _, _, _, _, message = event.pull("modem_message")
  if message == "wallConfirm" then
    promptWall()
  elseif message == "redTunnelConfirm" then
    io.write("Would you like to construct two redstone tunnels? (Y/N) ")
    answer = string.upper(io.read())
    if answer == "Y" then
      tunnel.send("Y")
      _, _, _, _, _, message = event.pull("modem_message")
      if message == "failed" then
        print("Operation failed. Not enough items.")
        os.sleep(2)
        computer.shutdown(true)
      elseif message == "success" then
        print("Confirmed operation. Constructing redstone tunnels now.")
      end
    elseif answer == "N" then
      print("Operation denied. Cancelling redstone tunnel construction.")
      tunnel.send("N")
      os.sleep(2)
      computer.shutdown(true)
    end
  end
end
