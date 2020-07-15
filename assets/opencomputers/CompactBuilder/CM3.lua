-- APIs

local robot = require("robot")
local component = require("component")
local computer = require("computer")
local me = component.upgrade_me
local db = component.database
local event = require("event")
local filesystem = require("filesystem")
local tunnel = component.tunnel

local forwardOffset=2

-- Visuals

function skipLine(number)
  for i = 1, number do
    print("")
  end
end

function printLoad(percent)
  if percent == "0" then
    os.execute("cls")
    skipLine(8)
    print("   Loading.    0%")
  elseif percent == "25" then
    os.execute("cls")
    skipLine(8)
    print("   Loading..  25%")
  elseif percent == "50" then
    os.execute("cls")
    skipLine(8)
    print("   Loading... 50%")
  elseif percent == "75" then
    os.execute("cls")
    skipLine(8)
    print("   Loading.   75%")
  elseif percent == "100" then
    os.execute("cls")
    skipLine(8)
    print("   Loading.. 100%")
  end
end

function writeTitle()
  print("     ███████████████████████████████████████")
  print("     █_|___|___|___|___|___|___|___|___|___█")
  print("     █___|__██████╗███╗___███╗██████╗_|___|█")
  print("     █_|___██╔════╝████╗ ████║╚════██╗_|___█")
  print("     █___|_██║___|_██╔████╔██║ █████╔╝|___|█")
  print("     █_|___██║_|___██║╚██╔╝██║ ╚═══██╗_|___█")
  print("     █___|_╚██████╗██║_╚═╝_██║██████╔╝|___|█")
  print("     █_|___|╚═════╝╚═╝_|___╚═╝╚═════╝__|___█")
  print("     █___A Compact Machines 3 Autobuilder_|█")
  print("     █_|___|___|___By: Samir___|___|___|___█")
  print("     ███████████████████████████████████████")
end

-- Wireless Mode

function getWirelessVariable()
  local file = io.open("wirelessVariable","r")
  if file:read() == "true" then
    modeWireless = true
  else
    modeWireless = nil
    file:close()
  end
end

function activateWireless()
  io.write("Would you like to activate wireless mode? (Y/N) ")
  answer = string.upper(io.read())
  if answer == "Y" then
    print("Connect your linked remote terminal to the robot. (Do 'wireless on')")
    _, _, _, _, _, message = event.pull("modem_message")
    if message == "wirelessOn" then
      local file=io.open("wirelessVariable","w")
      file:write("true")
      file:close()
      computer.shutdown(true)
    elseif answer == "N" then
      print("Cancelling wireless mode activation. Rebooting system.")
      os.sleep(2)
      computer.shutdown(true)
    end
  end
end

function deactivateWireless()
  local file=io.open("wirelessVariable","w")
  file:write("nil")
  file:close()
  computer.shutdown(true)
end

-- Item Functions

function totalItem(name)
  local size = 0
  for i = 1,16 do
    local data=component.inventory_controller.getStackInInternalSlot(i)
    if (data and data.name==name) then
      size = size + data.size
    end
  end
  return size
end

function selectItem(name)
  for i = 1,16 do
    local data=component.inventory_controller.getStackInInternalSlot(i)
    if (data and data.name==name) then
      robot.select(i)
      return
    end
  end
end

function selectEmpty()
  for i = 1,16 do
    local data=component.inventory_controller.getStackInInternalSlot(i)
    if data == nil then
      robot.select(i)
      return
    end
  end
end

function selectFull()
  for i = 1,16 do
    local data=component.inventory_controller.getStackInInternalSlot(i)
    if data ~= nil then
      robot.select(i)
      return
    end
  end
end

-- Request Functions

function requestWall()
  db.clear(1)
  db.clear(2)
  me.store({name = "minecraft:iron_block"}, db.address, 1)
  me.store({name = "minecraft:redstone"}, db.address, 2)
  selectEmpty()
  me.requestItems(db.address, 1, 1)
  selectEmpty()
  me.requestItems(db.address, 2, 2)
end

function requestMaxMachine()
  db.clear(1)
  db.clear(2)
  db.clear(3)
  me.store({name = "compactmachines3:wallbreakable"}, db.address, 1)
  me.store({name = "minecraft:ender_pearl"}, db.address, 2)
  me.store({name = "minecraft:emerald_block"}, db.address, 3)
  selectEmpty()
  me.requestItems(db.address, 1, 64)
  selectEmpty()
  me.requestItems(db.address, 1, 34)
  selectEmpty()
  me.requestItems(db.address, 2, 1)
  selectEmpty()
  me.requestItems(db.address, 3, 1)
end

function requestMinMachine()
  db.clear(1)
  db.clear(2)
  db.clear(3)
  me.store({name = "compactmachines3:wallbreakable"}, db.address, 1)
  me.store({name = "minecraft:ender_pearl"}, db.address, 2)
  me.store({name = "minecraft:gold_block"}, db.address, 3)
  selectEmpty()
  me.requestItems(db.address, 1, 26)
  selectEmpty()
  me.requestItems(db.address, 2, 1)
  selectEmpty()
  me.requestItems(db.address, 3, 1)
end

function requestTunnel()
  db.clear(1)
  db.clear(2)
  db.clear(3)
  me.store({name = "compactmachines3:wallbreakable"}, db.address, 1)
  me.store({name = "minecraft:redstone"}, db.address, 2)
  me.store({name = "minecraft:hopper"}, db.address, 3)
  selectEmpty()
  me.requestItems(db.address, 1, 1)
  selectEmpty()
  me.requestItems(db.address, 2, 8)
  selectEmpty()
  me.requestItems(db.address, 3, 1)
end

function requestRedTunnel()
  db.clear(1)
  db.clear(2)
  db.clear(3)
  me.store({name = "compactmachines3:wallbreakable"}, db.address, 1)
  me.store({name = "minecraft:redstone"}, db.address, 2)
  me.store({name = "minecraft:redstone_block"}, db.address, 3)
  selectEmpty()
  me.requestItems(db.address, 1, 1)
  selectEmpty()
  me.requestItems(db.address, 2, 9)
  selectEmpty()
  me.requestItems(db.address, 3, 1)
end

-- Check Functions

function checkMaxItems()
  if totalItem("minecraft:emerald_block") < 1 and totalItem("minecraft:ender_pearl") < 1 then
    print("Operation failed. Not enough emerald blocks or ender pearls.")
    os.sleep(2)
    computer.shutdown(true)
  elseif totalItem("minecraft:emerald_block") < 1 then
    print("Operation failed. Not enough emerald blocks.")
    os.sleep(2)
    computer.shutdown(true)
  elseif totalItem("minecraft:ender_pearl") < 1 then
    print("Operation failed. Not enough ender pearls.")
    os.sleep(2)
    computer.shutdown(true)
  end
end

function checkMinItems()
  if totalItem("minecraft:gold_block") < 1 and totalItem("minecraft:ender_pearl") < 1 then
    print("Operation failed. Not enough gold blocks or ender pearls.")
    os.sleep(2)
    computer.shutdown(true)
  elseif totalItem("minecraft:gold_block") < 1 then
    print("Operation failed. Not enough gold blocks.")
    os.sleep(2)
    computer.shutdown(true)
  elseif totalItem("minecraft:ender_pearl") < 1 then
    print("Operation failed. Not enough ender pearls.")
    os.sleep(2)
    computer.shutdown(true)
  end
end

function checkWallItems()
  if totalItem("minecraft:iron_block") < 1 and totalItem("minecraft:redstone") < 2 then
    print("Operation failed. Not enough iron blocks or redstone.")
    os.sleep(2)
    computer.shutdown(true)
  elseif totalItem("minecraft:iron_block") < 1 then
    print("Operation failed. Not enough iron blocks.")
    os.sleep(2)
    computer.shutdown(true)
  elseif totalItem("minecraft:redstone") < 2 then
    print("Operation failed. Not enough redstone.")
    os.sleep(2)
    computer.shutdown(true)
  end
end

function checkTunnelItems()
  if totalItem("minecraft:hopper") < 1 and totalItem("minecraft:redstone") < 8 then
    print("Operation failed. Not enough hoppers or redstone.")
    os.sleep(2)
    computer.shutdown(true)
  elseif totalItem("minecraft:hopper") < 1 then
    print("Operation failed. Not enough hoppers.")
    os.sleep(2)
    computer.shutdown(true)
  elseif totalItem("minecraft:redstone") < 8 then
    print("Operation failed. Not enough redstone.")
    os.sleep(2)
    computer.shutdown(true)
  end
end

function checkRedTunnelItems()
  if totalItem("minecraft:redstone_block") < 1 and totalItem("minecraft:redstone") < 8 then
    print("Operation failed. Not enough redstone blocks or redstone.")
    os.sleep(2)
    computer.shutdown(true)
  elseif totalItem("minecraft:redstone_block") < 1 then
    print("Operation failed. Not enough redstone blocks.")
    os.sleep(2)
    computer.shutdown(true)
  elseif totalItem("minecraft:redstone") < 8 then
    print("Operation failed. Not enough redstone.")
    os.sleep(2)
    computer.shutdown(true)
  end
end

-- Wireless Check Functions

function checkWirelessMaxItems()
  if totalItem("minecraft:emerald_block") < 1 and totalItem("minecraft:ender_pearl") < 1 then
    tunnel.send("failed")
    os.sleep(2)
    computer.shutdown(true)
  elseif totalItem("minecraft:emerald_block") < 1 then
    tunnel.send("failed")
    os.sleep(2)
    computer.shutdown(true)
  elseif totalItem("minecraft:ender_pearl") < 1 then
    tunnel.send("failed")
    os.sleep(2)
    computer.shutdown(true)
  else
    tunnel.send("success")
  end
end

function checkWirelessMinItems()
  if totalItem("minecraft:gold_block") < 1 and totalItem("minecraft:ender_pearl") < 1 then
    tunnel.send("failed")
    os.sleep(2)
    computer.shutdown(true)
  elseif totalItem("minecraft:gold_block") < 1 then
    tunnel.send("failed")
    os.sleep(2)
    computer.shutdown(true)
  elseif totalItem("minecraft:ender_pearl") < 1 then
    tunnel.send("failed")
    os.sleep(2)
    computer.shutdown(true)
  else
    tunnel.send("success")
  end
end

function checkWirelessWallItems()
  if totalItem("minecraft:iron_block") < 1 and totalItem("minecraft:redstone") < 2 then
    tunnel.send("failed")
    os.sleep(2)
    computer.shutdown(true)
  elseif totalItem("minecraft:iron_block") < 1 then
    tunnel.send("failed")
    os.sleep(2)
    computer.shutdown(true)
  elseif totalItem("minecraft:redstone") < 2 then
    tunnel.send("failed")
    os.sleep(2)
    computer.shutdown(true)
  else
    tunnel.send("success")
  end
end

function checkWirelessTunnelItems()
  if totalItem("minecraft:hopper") < 1 and totalItem("minecraft:redstone") < 8 then
    tunnel.send("failed")
    os.sleep(2)
    computer.shutdown(true)
  elseif totalItem("minecraft:hopper") < 1 then
    tunnel.send("failed")
    os.sleep(2)
    computer.shutdown(true)
  elseif totalItem("minecraft:redstone") < 8 then
    tunnel.send("failed")
    os.sleep(2)
    computer.shutdown(true)
  else
    tunnel.send("success")
  end
end

function checkWirelessRedTunnelItems()
  if totalItem("minecraft:redstone_block") < 1 and totalItem("minecraft:redstone") < 8 then
    tunnel.send("failed")
    os.sleep(2)
    computer.shutdown(true)
  elseif totalItem("minecraft:redstone_block") < 1 then
    tunnel.send("failed")
    os.sleep(2)
    computer.shutdown(true)
  elseif totalItem("minecraft:redstone") < 8 then
    tunnel.send("failed")
    os.sleep(2)
    computer.shutdown(true)
  else
    tunnel.send("success")
  end
end

-- ME Functions

function emptyIntoME()
  selectFull()
  me.sendItems()
  selectFull()
  me.sendItems()
  selectFull()
  me.sendItems()
  selectFull()
  me.sendItems()
  selectEmpty()
end

function startupEmptyIntoME()
  printLoad("0")
  selectFull()
  me.sendItems()
  printLoad("25")
  selectFull()
  me.sendItems()
  printLoad("50")
  selectFull()
  me.sendItems()
  printLoad("75")
  selectFull()
  me.sendItems()
  printLoad("100")
  selectEmpty()
end

-- Movement Functions

function forward (dist,place)
  for i = 1, dist do
    robot.forward()
    if place == "down" then
      selectItem("compactmachines3:wallbreakable")
      robot.placeDown()
    end
  end
end

function forwardTunnel (dist,place)
  for i = 1, dist do
    robot.forward()
    if place == "down" then
      selectItem("minecraft:redstone")
      robot.placeDown()
    end
  end
end

function back (dist,place)
  for i = 1, dist do
    robot.back()
    if place == "down" then
      robot.placeDown()
    elseif place == "up" then
      robot.placeUp()
    elseif place == "forward" then
      robot.place()
    end
  end
end

function up (dist)
  for i = 1, dist do
    robot.up()
  end
end

function down (dist)
  for i = 1, dist do
    robot.down()
  end
end

function undock()
  forward(forwardOffset,false)
end

function dock() 
  forward(3,false)
  robot.suck()
  back(2+forwardOffset,false)
end

-- Build Component Functions

function buildMaxPlatform()
  for i = 1,5 do
    forward(4,"down")
    if i == 5 then
      return
    end
    if i%2 == 1 then
      robot.turnRight()
      forward(1,"down")
      robot.turnRight()
    else
      robot.turnLeft()
      forward(1,"down")
      robot.turnLeft()
    end
  end
end

function buildMaxRing()
  for i = 1,12 do
    forward(4,"down")
    robot.turnLeft()
    if i == 4 then
      up(1)
    elseif i == 8 then
      forward(2,false)
      robot.turnLeft()
      forward(2,false)
      selectItem("minecraft:emerald_block")
      robot.placeDown()
      forward(2,false)
      robot.turnLeft()
      back(2,false)
      up(1)
    end
  end
end

function buildMinPlatform()
  for i = 1,3 do
    forward(2,"down")
    if i == 3 then
      return
    end
    if i % 2 == 1 then
      robot.turnRight()
      forward(1,"down")
      robot.turnRight()
    else
      robot.turnLeft()
      forward(1,"down")
      robot.turnLeft()
    end
  end
end

function buildMinRing()
  for i = 1,4 do
    forward(2,"down")
    robot.turnLeft()
  end
  forward(1,false)
  robot.turnLeft()
  forward(1,false)
  selectItem("minecraft:gold_block")
  robot.placeDown()
end

function buildTunnelLayer()
  for i = 1,4 do
    forwardTunnel(2,"down")
    robot.turnLeft()
  end
  forward(1,false)
  robot.turnLeft()
  forward(1,false)
  selectItem("compactmachines3:wallbreakable")
  robot.placeDown()
end

-- Craft Functions

function craftWall()
  requestWall()
  io.write("Would you like to construct sixteen machine walls? (Y/N) ")
  answer = string.upper(io.read())
  if answer == "Y" then
    checkWallItems()
    print("Confirmed operation. Constructing machine walls now.")
    undock()
    selectItem("minecraft:iron_block")
    robot.place()
    up(1)
    selectItem("minecraft:redstone")
    robot.place()
    down(1)
    back(1)
    robot.drop(1)
    os.sleep(5)
    dock()
    startProgram()
  elseif answer == "N" then
    print("Operation denied. Cancelling machine wall construction.")
    os.sleep(2)
    computer.shutdown(true)
  end
end

function craftNeededWall()
  emptyIntoME()
  requestWall()
  checkWallItems()
  print("Confirmed operation. Constructing machine walls now.")
  undock()
  selectItem("minecraft:iron_block")
  robot.place()
  up(1)
  selectItem("minecraft:redstone")
  robot.place()
  down(1)
  back(1)
  robot.drop(1)
  os.sleep(5)
  dock()
  startProgram()
end

function craftMaxMachine()
  requestMaxMachine()
  while totalItem("compactmachines3:wallbreakable") < 98 do
    io.write("Insufficient amount of walls. Would you like to construct more now? (Y/N) ")
    answer = string.upper(io.read())
    if answer == "Y" then
      craftNeededWall()
    elseif answer == "N" then
      print("Operation denied. Cancelling machine wall construction.")
      os.sleep(2)
      computer.shutdown(true)
    end
  end

  if totalItem("compactmachines3:wallbreakable") >= 98 then
    io.write("Would you like to construct a maximum compact machine? (5x5x5) (Y/N) ")
    answer = string.upper(io.read())
    if answer == "Y" then
      checkMaxItems()
      print("Confirmed operation. Constructing compact machine now.")
      undock()
      selectItem("compactmachines3:wallbreakable")
      robot.turnLeft()
      forward(2,false)
      robot.turnRight()
      up(1)
      forward(1,"down")
      buildMaxPlatform()
      up(1)
      robot.turnLeft()
      buildMaxRing()
      robot.turnLeft()
      up(1)
      selectItem("compactmachines3:wallbreakable")
      robot.placeDown()
      buildMaxPlatform()
      robot.turnLeft()
      forward(2,false)
      robot.turnRight()
      back(6,false)
      down(5)
      selectItem("minecraft:ender_pearl")
      robot.drop(1)
      os.sleep(33)
      dock()
      startProgram()
    elseif answer == "N" then
      print("Operation denied. Cancelling compact machine construction.")
      os.sleep(2)
      computer.shutdown(true)
    end
  end
end

function craftMinMachine()
  requestMinMachine()
  while totalItem("compactmachines3:wallbreakable") < 26 do
    io.write("Insufficient amount of walls. Would you like to construct more now? (Y/N) ")
    answer = string.upper(io.read())
    if answer == "Y" then
      craftNeededWall()
    elseif answer == "N" then
      print("Operation denied. Cancelling machine wall construction.")
      os.sleep(2)
      computer.shutdown(true)
    end
  end

  if totalItem("compactmachines3:wallbreakable") >= 26 then
    io.write("Would you like to construct a normal compact machine? (3x3x3) (Y/N) ")
    answer = string.upper(io.read())
    if answer == "Y" then
      checkMinItems()
      print("Confirmed operation. Constructing compact machine now.")
      undock()
      selectItem("compactmachines3:wallbreakable")
      robot.turnLeft()
      forward(1,false)
      robot.turnRight()
      up(1)
      forward(1,"down")
      buildMinPlatform()
      up(1)
      robot.turnLeft()
      buildMinRing()
      up(1)
      back(1)
      robot.turnLeft()
      back(1)
      selectItem("compactmachines3:wallbreakable")
      robot.placeDown()
      buildMinPlatform()
      robot.turnLeft()
      back(1,false)
      robot.turnRight()
      back(1,false)
      down(3)
      robot.turnLeft()
      back(1)
      selectItem("minecraft:ender_pearl")
      robot.drop(1)
      os.sleep(24)
      dock()
      startProgram()
    elseif answer == "N" then
      print("Operation denied. Cancelling compact machine construction.")
      os.sleep(2)
      computer.shutdown(true)
    end
  end
end

function craftTunnel()
  requestTunnel()
  while totalItem("compactmachines3:wallbreakable") < 1 do
    io.write("Insufficient amount of walls. Would you like to construct more now? (Y/N) ")
    answer = string.upper(io.read())
    if answer == "Y" then
      craftNeededWall()
    elseif answer == "N" then
      print("Operation denied. Cancelling machine wall construction.")
      os.sleep(2)
      computer.shutdown(true)
    end
  end

  if totalItem("compactmachines3:wallbreakable") > 0 then
    io.write("Would you like to construct two tunnels? (Y/N) ")
    answer = string.upper(io.read())
    if answer == "Y" then
      checkTunnelItems()
      print("Confirmed operation. Constructing tunnels now.")
      undock()
      robot.turnRight()
      forward(1)
      robot.turnLeft()
      up(1)
      forward(1)
      buildTunnelLayer()
      up(1)
      selectItem("minecraft:hopper")
      robot.placeDown()
      robot.turnRight()
      back(3)
      down(2)
      me.requestItems(db.address,2,1)     
      selectItem("minecraft:redstone")
      robot.drop(1)
      os.sleep(10)
      dock()
      startProgram()
    elseif answer == "N" then
      print("Operation denied. Cancelling tunnel construction.")
      os.sleep(2)
      computer.shutdown(true)
    end
  end
end

function craftRedTunnel()
  requestRedTunnel()
  while totalItem("compactmachines3:wallbreakable") < 1 do
    io.write("Insufficient amount of walls. Would you like to construct more now? (Y/N) ")
    answer = string.upper(io.read())
    if answer == "Y" then
      craftNeededWall()
    elseif answer == "N" then
      print("Operation denied. Cancelling machine wall construction.")
      os.sleep(2)
      computer.shutdown(true)
    end
  end

  if totalItem("compactmachines3:wallbreakable") > 0 then
    io.write("Would you like to construct two redstone tunnels? (Y/N) ")
    answer = string.upper(io.read())
    if answer == "Y" then
      checkRedTunnelItems()
      print("Confirmed operation. Constructing redstone tunnels now.")
      undock()
      robot.turnRight()
      forward(1)
      robot.turnLeft()
      up(1)
      forward(1)
      buildTunnelLayer()
      up(1)
      selectItem("minecraft:redstone_block")
      robot.placeDown()
      robot.turnRight()
      back(3)
      down(2)
      selectItem("minecraft:redstone")
      robot.drop(1)
      os.sleep(10)
      dock()
      startProgram()
    elseif answer == "N" then
      print("Operation denied. Cancelling tunnel construction.")
      os.sleep(2)
      computer.shutdown(true)
    end
  end
end

-- Wireless Craft Functions

function wirelessCraftWall()
  requestWall()
  tunnel.send("wallConfirm")
  _, _, _, _, _, message = event.pull("modem_message")
  if message == "Y" then
    checkWirelessWallItems()
    undock()
    selectItem("minecraft:iron_block")
    robot.place()
    up(1)
    selectItem("minecraft:redstone")
    robot.place()
    down(1)
    back(1)
    robot.drop(1)
    os.sleep(5)
    dock()
    startWirelessProgram()
  elseif message == "N" then
    os.sleep(2)
    computer.shutdown(true)
  end
end

function wirelessCraftNeededWall()
  emptyIntoME()
  requestWall()
  checkWirelessWallItems()
  undock()
  selectItem("minecraft:iron_block")
  robot.place()
  up(1)
  selectItem("minecraft:redstone")
  robot.place()
  down(1)
  back(1)
  robot.drop(1)
  os.sleep(5)
  dock()
  startWirelessProgram()
end

function wirelessCraftMaxMachine()
  requestMaxMachine()
  while totalItem("compactmachines3:wallbreakable") < 98 do
    tunnel.send("wallConfirm")
    _, _, _, _, _, message = event.pull("modem_message")
    if message == "Y" then
      wirelessCraftNeededWall()
    elseif message == "N" then
      os.sleep(2)
      computer.shutdown(true)
    end
  end

  if totalItem("compactmachines3:wallbreakable") >= 98 then
    tunnel.send("maxMachineConfirm")
    _, _, _, _, _, message = event.pull("modem_message")
    if message == "Y" then
      checkWirelessMaxItems()
      undock()
      selectItem("compactmachines3:wallbreakable")
      robot.turnLeft()
      forward(2,false)
      robot.turnRight()
      up(1)
      forward(1,"down")
      buildMaxPlatform()
      up(1)
      robot.turnLeft()
      buildMaxRing()
      robot.turnLeft()
      up(1)
      selectItem("compactmachines3:wallbreakable")
      robot.placeDown()
      buildMaxPlatform()
      robot.turnLeft()
      forward(2,false)
      robot.turnRight()
      back(6,false)
      down(5)
      selectItem("minecraft:ender_pearl")
      robot.drop(1)
      os.sleep(33)
      dock()
      startWirelessProgram()
    elseif message == "N" then
      os.sleep(2)
      computer.shutdown(true)
    end
  end
end

function wirelessCraftMinMachine()
  requestMinMachine()
  while totalItem("compactmachines3:wallbreakable") < 26 do
    tunnel.send("wallConfirm")
    _, _, _, _, _, message = event.pull("modem_message")
    if message == "Y" then
      wirelessCraftNeededWall()
    elseif message == "N" then
      os.sleep(2)
      computer.shutdown(true)
    end
  end

  if totalItem("compactmachines3:wallbreakable") >= 26 then
    tunnel.send("minMachineConfirm")
    _, _, _, _, _, message = event.pull("modem_message")
    if message == "Y" then
      checkWirelessMinItems()
      undock()
      selectItem("compactmachines3:wallbreakable")
      robot.turnLeft()
      forward(1,false)
      robot.turnRight()
      up(1)
      forward(1,"down")
      buildMinPlatform()
      up(1)
      robot.turnLeft()
      buildMinRing()
      up(1)
      back(1)
      robot.turnLeft()
      back(1)
      selectItem("compactmachines3:wallbreakable")
      robot.placeDown()
      buildMinPlatform()
      robot.turnLeft()
      back(1,false)
      robot.turnRight()
      back(1,false)
      down(3)
      robot.turnLeft()
      back(1)
      selectItem("minecraft:ender_pearl")
      robot.drop(1)
      os.sleep(24)
      dock()
      startWirelessProgram()
    elseif message == "N" then
      os.sleep(2)
      computer.shutdown(true)
    end
  end
end

function wirelessCraftTunnel()
  requestTunnel()
  while totalItem("compactmachines3:wallbreakable") < 1 do
    tunnel.send("wallConfirm")
    _, _, _, _, _, message = event.pull("modem_message")
    if message == "Y" then
      wirelessCraftNeededWall()
    elseif message == "N" then
      os.sleep(2)
      computer.shutdown(true)
    end
  end

  if totalItem("compactmachines3:wallbreakable") > 0 then
    tunnel.send("tunnelConfirm")
    _, _, _, _, _, message = event.pull("modem_message")
    if message == "Y" then
      checkWirelessTunnelItems()
      undock()
      robot.turnRight()
      forward(1)
      robot.turnLeft()
      up(1)
      forward(1)
      buildTunnelLayer()
      up(1)
      selectItem("minecraft:hopper")
      robot.placeDown()
      robot.turnRight()
      back(3)
      down(2)
      me.requestItems(db.address,2,1)
      selectItem("minecraft:redstone")
      robot.drop(1)
      os.sleep(10)
      dock()
      startWirelessProgram()
    elseif message == "N" then
      os.sleep(2)
      computer.shutdown(true)
    end
  end
end

function wirelessCraftRedTunnel()
  requestRedTunnel()
  while totalItem("compactmachines3:wallbreakable") < 1 do
    tunnel.send("wallConfirm")
    _, _, _, _, _, message = event.pull("modem_message")
    if message == "Y" then
      wirelessCraftNeededWall()
    elseif message == "N" then
      os.sleep(2)
      computer.shutdown(true)
    end
  end

  if totalItem("compactmachines3:wallbreakable") > 0 then
    tunnel.send("redTunnelConfirm")
    _, _, _, _, _, message = event.pull("modem_message")
    if message == "Y" then
      checkWirelessRedTunnelItems()
      undock()
      robot.turnRight()
      forward(1)
      robot.turnLeft()
      up(1)
      forward(1)
      buildTunnelLayer()
      up(1)
      selectItem("minecraft:redstone_block")
      robot.placeDown()
      robot.turnRight()
      back(3)
      down(2)
      selectItem("minecraft:redstone")
      robot.drop(1)
      os.sleep(10)
      dock()
      startWirelessProgram()
    elseif message == "N" then
      os.sleep(2)
      computer.shutdown(true)
    end
  end
end

-- Command Line Arguments

function commandLineArgs()
  skipLine(1)
  print("  What would you like to build?")
  print("(maxMachine, minMachine, walls, tunnel, redTunnel)")
  toBuild = string.upper(io.read())
  if toBuild == "MAXMACHINE" then
    craftMaxMachine()
  elseif toBuild == "MINMACHINE" then
    craftMinMachine()
  elseif toBuild == "WALLS" then
    craftWall()
  elseif toBuild == "TUNNEL" then
    craftTunnel()
  elseif toBuild == "REDTUNNEL" then
    craftRedTunnel()
  elseif toBuild == "WIRELESS" then
    activateWireless()
  end
end

function wirelessArgs()
  skipLine(1)
  print("    Wireless Mode")
  _, _, _, _, _, message = event.pull("modem_message")
  if message == "walls" then
    wirelessCraftWall()
  elseif message == "maxMachine" then
    wirelessCraftMaxMachine()
  elseif message == "minMachine" then
    wirelessCraftMinMachine()
  elseif message == "tunnel" then
    wirelessCraftTunnel()
  elseif message == "redTunnel" then
    wirelessCraftRedTunnel()
  elseif message == "wirelessOff" then
    deactivateWireless()
  end
end

-- Start Program

function writeShell()
  local shell = io.open(".shrc","w")
  shell:write("/home/CM3.lua")
  shell:close()
end

function createWirelessVariable()
  if not filesystem.exists("/home/wirelessVariable") then
    local file = io.open("wirelessVariable","w")
    file:write("")
    file:close()
  end
end

function startProgram()
  tunnel.send("off")
  startupEmptyIntoME()
  os.execute("cls")
  writeTitle()
  commandLineArgs()
end

function startWirelessProgram()
  tunnel.send("on")
  startupEmptyIntoME()
  os.execute("cls")
  writeTitle()
  wirelessArgs()
end

writeShell()
createWirelessVariable()
getWirelessVariable()

if modeWireless == nil then
  startProgram()
elseif modeWireless == true then
  startWirelessProgram()
end