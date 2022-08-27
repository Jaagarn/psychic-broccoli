-- Imports
local Draw = require "Draw"
local Room = require "Room"
local SpecialRoom = require "SpecialRoom"
local Chunk = require "Chunk"
local PathMaker = require "PathMaker"
local ConnectionMaker = require "ConnectionMaker"

-- Class
local MapGenerator = {height = 0, width = 0, map = {}, chunkYSide = 0, chunkXside = 0, chunks = {}}
local MapGeneratorMT = {__index = MapGenerator}

-- Private Methods

-- Just creates and empty array that is the basis for the whole map. This is also why y and x are "flipped",
-- I.E you natually add all rows before you add columns in an 2D array.
local function createMap ()
  
  local map  = {}
  for i=1,MapGenerator.height do
    map[i] = {}
    for j=1,MapGenerator.width do
      map[i][j] = Draw.MapPixel.EMPTY
    end
  end
  
  return map
  
end

-- Adds rooms of random size and width to the empty map. posY and posX are the starting position on the map.
-- maxY and maxX is the maximum height and width for contanier of the room. So "class" Room will produce a random sized room that
-- can be contained inside the maxY and maxX and the rest of container will be empty
local function addRoom (posY, posX, maxY, maxX, seed)
  
  local room = Room:new(nil, maxY, maxX, seed)
  local roomMap = room:getRoomMap()
  local roomMapY = 1
  
  for i=posY, posY + maxY - 1 do
    local roomMapX = 1
    for j=posX, posX + maxX - 1 do
      MapGenerator.map[i][j] = roomMap[roomMapY][roomMapX]
      roomMapX = roomMapX + 1
    end
    roomMapY = roomMapY + 1
  end
  
  return room

end

-- Works the same as a normal room, but is not random, it's a premade room that is the same every time. whatKind is which
-- special room that should be added. chunkY and chunkX is the place of the 10*10 chunks that exist and is used to 
-- determine where the special room should be placed
local function addSpecialRoom(posY, posX, maxY, maxX, whatKind, chunkY, chunkX)

  local room = SpecialRoom:new(nil, maxY, maxX, whatKind, chunkY, chunkX)
  local roomMap = room:getRoomMap()
  local roomMapY = 1
  
  for i=posY, posY + maxY - 1 do
    local roomMapX = 1
    for j=posX, posX + maxX - 1 do
      MapGenerator.map[i][j] = roomMap[roomMapY][roomMapX]
      roomMapX = roomMapX + 1
    end
    roomMapY = roomMapY + 1
  end
  
  return room
end

-- Fills the map created by createMap() with rooms. It also created chunks (10*10) that keep track of where a floor tile exists in the 
-- chunk if a room exists. Otherwise it takes roughly the middle point of the chunk and stores that. This will be used later to create
-- paths and connections between the chunks, and therefore the rooms.
-- There is a 20% chance that no room will be added to a chunk for variance
local function fillMapWithRooms()
  
  math.randomseed(os.time())
  local endCorner = math.random(1,4)
  local endRoomY = 0
  local endRoomX = 0
  local startRoomY = math.random(5,6)
  local startRoomX = math.random(5,6)
  
  if(endCorner == 1) then
    endRoomY = 1
    endRoomX = 1
  elseif(endCorner == 2) then
    endRoomY = 1
    endRoomX = 10
  elseif(endCorner == 3) then
    endRoomY = 1
    endRoomX = 10
  else
    endRoomY = 10
    endRoomX = 10
  end
  
  local addedAllY = 1
  local yChunk = 1
  
  while (addedAllY <= MapGenerator.height)
  do
    local addedAllXInARow = 1
    local xChunk = 1
  
    while(addedAllXInARow <= MapGenerator.width)
    do
      if(yChunk == endRoomY and xChunk == endRoomX) then
        local room = addSpecialRoom(addedAllY, addedAllXInARow, MapGenerator.chunkYSide, MapGenerator.chunkXside, Draw.SpecialRoom.ENDINGROOM, yChunk, xChunk)
        local roomX, roomY = room:getAYXPointInRoom()
        local newChunk = Chunk:new(nil, math.floor(addedAllY + (MapGenerator.chunkYSide/2)), math.floor(addedAllXInARow + (MapGenerator.chunkXside/2)), addedAllY + roomX, addedAllXInARow + roomY, false)
        MapGenerator.chunks[yChunk][xChunk] = newChunk
      elseif(yChunk == startRoomY and xChunk == startRoomX) then
        local room = addSpecialRoom(addedAllY, addedAllXInARow, MapGenerator.chunkYSide, MapGenerator.chunkXside, Draw.SpecialRoom.STARTINGROOM, yChunk, xChunk)
        local roomX, roomY = room:getAYXPointInRoom()
        local newChunk = Chunk:new(nil, math.floor(addedAllY + (MapGenerator.chunkYSide/2)), math.floor(addedAllXInARow + (MapGenerator.chunkXside/2)), addedAllY + roomX, addedAllXInARow + roomY, false)
        MapGenerator.chunks[yChunk][xChunk] = newChunk
      else
        local seed = addedAllY*addedAllXInARow*os.time()
        math.randomseed(seed)
        local twentyProcentChance = math.random(1, 10)
        if(twentyProcentChance <= 8) then
          local room = addRoom(addedAllY, addedAllXInARow, MapGenerator.chunkYSide, MapGenerator.chunkXside, seed)
          local roomX, roomY = room:getAYXPointInRoom()
          local newChunk = Chunk:new(nil, math.floor(addedAllY + (MapGenerator.chunkYSide/2)), math.floor(addedAllXInARow + (MapGenerator.chunkXside/2)), addedAllY + roomX, addedAllXInARow + roomY, false)
          MapGenerator.chunks[yChunk][xChunk] = newChunk
        else
          local newChunk = Chunk:new(nil, math.floor(addedAllY + (MapGenerator.chunkYSide/2)), math.floor(addedAllXInARow + (MapGenerator.chunkXside/2)), nil, nil, true)
          MapGenerator.chunks[yChunk][xChunk] = newChunk
        end
      end
      xChunk = xChunk + 1
      addedAllXInARow = addedAllXInARow + MapGenerator.chunkXside
    end
    yChunk = yChunk + 1 
    addedAllY = addedAllY + MapGenerator.chunkYSide;
  end
end

-- When everything else has been added the walls are drawn where there is empty tiles around a floor tile
local function drawWalls()
  for i=1,MapGenerator.height do
    for j=1,MapGenerator.width do
      if(MapGenerator.map[i][j] == Draw.MapPixel.FLOOR) then
        for k = i-1, i+1 do
          for l = j-1, j+1 do
            if(MapGenerator.map[k][l] == Draw.MapPixel.EMPTY) then
              MapGenerator.map[k][l] = Draw.MapPixel.WALL
            end
          end
        end
      end
    end
  end
end

-- Constructor
function MapGenerator:new (o, mapSize)
  local o = o or {}
  
  if(mapSize == 1) then
    self.height = 100
    self.width = 200
    self.chunkYSide = 10
    self.chunkXside = 20
  elseif(mapSize == 2) then
    self.height = 150
    self.width = 300
    self.chunkYSide = 15
    self.chunkXside = 30
  elseif(mapSize == 3) then
    self.height = 200
    self.width = 400
    self.chunkYSide = 20
    self.chunkXside = 40 
  else
    self.height = 100
    self.width = 200
    self.chunkYSide = 10
    self.chunkXside = 20
  end
  
  for i=1, 10 do
    MapGenerator.chunks[i] = {}
    for j=1, 10 do
      MapGenerator.chunks[i][j] = 0
    end
  end
  
  self.map = createMap()
  fillMapWithRooms()
  
  local pathMaker = PathMaker:new(nil, self.chunks, self.map)
  self.chunks, self.map = pathMaker:getChunksAndMapWithPaths()
  
  local connectionMaker = ConnectionMaker:new(nil, self.chunks, self.map, self.chunkYSide, self.chunkXside)
  self.chunks, self.map = connectionMaker:getChunksAndMapWithConnections()
  
  drawWalls()
  
  return setmetatable(o, MapGeneratorMT)
end

-- Public Methods
function MapGenerator:getHeight ()
  return MapGenerator.height
end

function MapGenerator:getWidth ()
  return MapGenerator.width
end

function MapGenerator:getMap ()
  return MapGenerator.map
end
  
return MapGenerator