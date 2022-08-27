-- Imports
local Draw = require "Draw"
local Room = require "Room"
local MapGenerator = require "MapGenerator"

-- Second value is size. 1: (y = 100, x = 200), 2: (y = 150, x = 300), 3: (y = 200, x = 400)
local mapGenerator = MapGenerator:new(nil, 2)

Draw:printMap(mapGenerator.getMap(), mapGenerator.getHeight(), mapGenerator.getWidth())

local continueCreatingMaps = true

-- Just an simple while statement so you can keep printing maps if you want to. And to show that 
-- each created map is different
while(continueCreatingMaps == true) do
  print("Print a new map (y/n)?")
  local answer=io.read()
  if answer=="y" then
    print("1: (y = 100, x = 200), 2: (y = 150, x = 300), 3: (y = 200, x = 400)")
    local newAnswer=io.read()
    if(newAnswer == "1") then
      local mapGenerator1 = MapGenerator:new(nil, 1)
      Draw:printMap(mapGenerator1.getMap(), mapGenerator1.getHeight(), mapGenerator1.getWidth())
    elseif(newAnswer == "2") then
      local mapGenerator2 = MapGenerator:new(nil, 2)
      Draw:printMap(mapGenerator2.getMap(), mapGenerator2.getHeight(), mapGenerator2.getWidth())
    elseif(newAnswer == "3") then
      local mapGenerator3 = MapGenerator:new(nil, 3)
      Draw:printMap(mapGenerator3.getMap(), mapGenerator3.getHeight(), mapGenerator3.getWidth())
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


