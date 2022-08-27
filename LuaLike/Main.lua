-- Imports
local Draw = require "Draw"
local MapGenerator = require "MapGenerator"

-- Second value is size. 1: (y = 100, x = 200), 2: (y = 150, x = 300), 3: (y = 200, x = 400)
local mapGenerator = MapGenerator:new(nil, 1)

Draw:printMap(mapGenerator:getMap(), mapGenerator:getHeight(), mapGenerator:getWidth())

local continueCreatingMaps = true

-- Just an simple while statement so you can keep printing maps if you want to. And to show that 
-- each created map is different
while(continueCreatingMaps == true) do
  print("Print a new map (y/n)?")
  local answer = io.read()
  if answer=="y" then
    print("Please enter a number between 1-4")
    print("1: (y = 100, x = 200), 2: (y = 150, x = 300), 3: (y = 200, x = 400), 4: custom y and x")
    local newAnswer = io.read()
    if(newAnswer == "1") then
      local mapGenerator1 = MapGenerator:new(nil, 1)
      Draw:printMap(mapGenerator1:getMap(), mapGenerator1:getHeight(), mapGenerator1:getWidth())
    elseif(newAnswer == "2") then
      local mapGenerator2 = MapGenerator:new(nil, 2)
      Draw:printMap(mapGenerator2:getMap(), mapGenerator2:getHeight(), mapGenerator2:getWidth())
    elseif(newAnswer == "3") then
      local mapGenerator3 = MapGenerator:new(nil, 3)
      Draw:printMap(mapGenerator3:getMap(), mapGenerator3:getHeight(), mapGenerator3:getWidth())
    elseif(newAnswer == "4") then

      print("Please enter a number between 1-5 for ySide")
      print("1: 100, 2: 150, 3: 200, 4: 300, 5: 400")
      local yComplete = false;
      local ySide = 0;

      while (yComplete ~= true) do
        local ySideInput = io.read()
        if(ySideInput == "1") then
          ySide = 100
          yComplete = true
        elseif(ySideInput == "2") then
          ySide = 150
          yComplete = true
        elseif(ySideInput == "3") then
          ySide = 200
          yComplete = true
        elseif(ySideInput == "4") then
          ySide = 300
          yComplete = true
        elseif(ySideInput == "5") then
          ySide = 400
          yComplete = true
        else
          print("Please enter a number between 1-5 for ySide")
          print("1: 100, 2: 150, 3: 200, 4: 300, 5: 400")
        end
      end

      print("Please enter a number between 1-5 for xSide")
      print("1: 100, 2: 150, 3: 200, 4: 300, 5: 400")
      local xComplete = false;
      local xSide = 0;

      while (xComplete ~= true) do
        local xSideInput = io.read()
        if(xSideInput == "1") then
          xSide = 100
          xComplete = true
        elseif(xSideInput == "2") then
          xSide = 150
          xComplete = true
        elseif(xSideInput == "3") then
          xSide = 200
          xComplete = true
        elseif(xSideInput == "4") then
          xSide = 300
          xComplete = true
        elseif(xSideInput == "5") then
          xSide = 400
          xComplete = true
        else
          print("Please enter a number between 1-5 for xSide")
          print("1: 100, 2: 150, 3: 200, 4: 300, 5: 400")
        end
      end

      local mapGenerator4 = MapGenerator:new(nil, nil, ySide, xSide )
      Draw:printMap(mapGenerator4:getMap(), mapGenerator4:getHeight(), mapGenerator4:getWidth())
    else
      print("Invalid input, try again")
    end
  elseif answer=="n" then
    print("Bye bye!")
    continueCreatingMaps = false
  else
    print("Invalid input, try again")
  end
end


