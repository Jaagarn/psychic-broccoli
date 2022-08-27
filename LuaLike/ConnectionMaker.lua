-- Imports
local Draw = require("Draw")

-- Class
local ConnectionMaker = 
{ chunks = {}, 
  map = {},
  chunkYSide = 0,
  chunkXSide = 0}
local ConnectionMakerMT = {__index = ConnectionMaker}

-- Private methods

-- Gets the a y,x point for a chunk. Which is taken (a point in a room or the middle of the chunk) depends on if the chunk has a room or not.
local function getYXFromChunk(chunk)
  
  local chunkY = 0
  local chunkX = 0
  
  if(chunk:isEmpty() == true) then
    chunkY = chunk:getMiddleY()
    chunkX = chunk:getMiddleX()
  else
    chunkY = chunk:getMiddleYRoom()
    chunkX = chunk:getMiddleXRoom()
  end
  return chunkY, chunkX
  
end

-- Connects two chunks from different sections bottom to top. When it gets to the edge of the bottom chunk it creates a closed door. 
local function connectTopRowSections(y, x)
  
  local firstChunk = ConnectionMaker.chunks[y][x]
  local secondChunk = ConnectionMaker.chunks[y-1][x]
  
  local firstChunkTopEdge = firstChunk:getMiddleY() - math.floor((ConnectionMaker.chunkYSide / 2))
    
  local firstChunkY = 0
  local firstChunkX = 0
  
  firstChunkY, firstChunkX = getYXFromChunk(firstChunk)
  
  local secondChunkY = 0
  local secondChunkX = 0
    
  secondChunkY, secondChunkX = getYXFromChunk(secondChunk)
   
  while(firstChunkX ~= secondChunkX) do
    ConnectionMaker.map[firstChunkY][firstChunkX] = Draw.MapPixel.FLOOR
    
    if(firstChunkX > secondChunkX) then
      firstChunkX = firstChunkX - 1
      
    elseif(firstChunkX < secondChunkX) then
      firstChunkX = firstChunkX + 1
    end
    
  end
  
  while(firstChunkY ~= secondChunkY) do
    
    if(firstChunkY == firstChunkTopEdge) then
      ConnectionMaker.map[firstChunkY][firstChunkX] = Draw.MapPixel.CLOSEDDOOR
    else
      ConnectionMaker.map[firstChunkY][firstChunkX] = Draw.MapPixel.FLOOR
    end

    firstChunkY = firstChunkY - 1
  end
  
end

-- Connects two chunks from different sections top to bottom. When it gets to the edge of the top chunk it creates a closed door. 
local function connectBottomRowSections(y, x)
  
  local firstChunk = ConnectionMaker.chunks[y][x]
  local secondChunk = ConnectionMaker.chunks[y+1][x]
  
  local firstChunkBottomEdge = firstChunk:getMiddleY() + math.floor((ConnectionMaker.chunkYSide / 2))
    
  local firstChunkY = 0
  local firstChunkX = 0
  
  firstChunkY, firstChunkX = getYXFromChunk(firstChunk)
  
  local secondChunkY = 0
  local secondChunkX = 0
    
  secondChunkY, secondChunkX = getYXFromChunk(secondChunk)
  
  local leftFirstSection = false
   
   while(firstChunkX ~= secondChunkX) do
    ConnectionMaker.map[firstChunkY][firstChunkX] = Draw.MapPixel.FLOOR
    
    if(firstChunkX > secondChunkX) then
      firstChunkX = firstChunkX - 1
      
    elseif(firstChunkX < secondChunkX) then
      firstChunkX = firstChunkX + 1
      
    end
    
  end
  
  while(firstChunkY ~= secondChunkY) do
    if(firstChunkY == firstChunkBottomEdge) then
      ConnectionMaker.map[firstChunkY][firstChunkX] = Draw.MapPixel.CLOSEDDOOR
    else
      ConnectionMaker.map[firstChunkY][firstChunkX] = Draw.MapPixel.FLOOR
    end
    firstChunkY = firstChunkY + 1
        
  end
  
end

-- Connects two chunks from different sections right to left. When it gets to the edge of the right chunk it creates a closed door. 
local function connectRightColumnSections(y, x)
  
  local firstChunk = ConnectionMaker.chunks[y][x]
  local secondChunk = ConnectionMaker.chunks[y][x+1]
  
  local firstChunkRightEdge = firstChunk:getMiddleX() + math.floor((ConnectionMaker.chunkXSide / 2))
    
  local firstChunkY = 0
  local firstChunkX = 0
  
  firstChunkY, firstChunkX = getYXFromChunk(firstChunk)
  
  local secondChunkY = 0
  local secondChunkX = 0
    
  secondChunkY, secondChunkX = getYXFromChunk(secondChunk)
  
  while(firstChunkY ~= secondChunkY) do
    ConnectionMaker.map[firstChunkY][firstChunkX] = Draw.MapPixel.FLOOR

    if(firstChunkY > secondChunkY) then
      firstChunkY = firstChunkY - 1
    elseif(firstChunkY < secondChunkY) then
      firstChunkY = firstChunkY + 1
    end
        
  end
   
  while(firstChunkX ~= secondChunkX) do
    if(firstChunkX == firstChunkRightEdge) then
      ConnectionMaker.map[firstChunkY][firstChunkX] = Draw.MapPixel.CLOSEDDOOR
    else
      ConnectionMaker.map[firstChunkY][firstChunkX] = Draw.MapPixel.FLOOR
    end
    
    firstChunkX = firstChunkX + 1
  end
  
end

-- Connects two chunks from different sections left to right. When it gets to the edge of the left chunk it creates a closed door. 
local function connectLeftColumnSections(y, x)
  
  local firstChunk = ConnectionMaker.chunks[y][x]
  local secondChunk = ConnectionMaker.chunks[y][x-1]
  
  local firstChunkRightEdge = firstChunk:getMiddleX() - math.floor((ConnectionMaker.chunkXSide / 2))
    
  local firstChunkY = 0
  local firstChunkX = 0
  
  firstChunkY, firstChunkX = getYXFromChunk(firstChunk)
  
  local secondChunkY = 0
  local secondChunkX = 0
    
  secondChunkY, secondChunkX = getYXFromChunk(secondChunk)
   
  while(firstChunkY ~= secondChunkY) do
    ConnectionMaker.map[firstChunkY][firstChunkX] = Draw.MapPixel.FLOOR

    if(firstChunkY > secondChunkY) then
      firstChunkY = firstChunkY - 1
    elseif(firstChunkY < secondChunkY) then
      firstChunkY = firstChunkY + 1
    end
        
  end
   
  while(firstChunkX ~= secondChunkX) do
    if(firstChunkX == firstChunkRightEdge) then
      ConnectionMaker.map[firstChunkY][firstChunkX] = Draw.MapPixel.CLOSEDDOOR
    else
      ConnectionMaker.map[firstChunkY][firstChunkX] = Draw.MapPixel.FLOOR
    end

    firstChunkX = firstChunkX - 1
  end
  
end

-- Connects all sections from inside out. Each section will have four connections. Two to the inside and two to the outside 
-- (unless it's the center or the edge sections that only has two outside respective two inside connections).
-- A connection between any section will have one top or bottom and one right or left choosen randomly.
local function connectSections()
  
  local connectRowSectionsXMin = 5
  local connectRowSectionsXMax = 6
  
  while(connectRowSectionsXMin > 1) do
      
    local topOrBottom = math.random(1,2)
    if(topOrBottom == 1) then
      local randomY = math.random(connectRowSectionsXMin, connectRowSectionsXMax)
      connectTopRowSections(connectRowSectionsXMin, randomY)
    elseif(topOrBottom == 2) then
      local randomY = math.random(connectRowSectionsXMin, connectRowSectionsXMax)
      connectBottomRowSections(connectRowSectionsXMax, randomY)
    end
      
    connectRowSectionsXMin = connectRowSectionsXMin - 1
    connectRowSectionsXMax = connectRowSectionsXMax + 1
  end
    
  local connectColumnSectionsYMin = 5
  local connectColumnSectionsYMax = 6
  
  while(connectColumnSectionsYMin > 1) do
      
    local leftOrRight = math.random(1,2)
    if(leftOrRight == 1) then
      local randomX = math.random(connectColumnSectionsYMin, connectColumnSectionsYMax)
      connectLeftColumnSections(randomX, connectColumnSectionsYMin)
    elseif(leftOrRight == 2) then
      local randomX = math.random(connectColumnSectionsYMin, connectColumnSectionsYMax)
      connectRightColumnSections(randomX, connectColumnSectionsYMax)
    end
      
    connectColumnSectionsYMin = connectColumnSectionsYMin - 1
    connectColumnSectionsYMax = connectColumnSectionsYMax + 1
  end
  
end

-- Constructor
function ConnectionMaker:new (o, chunks, map, chunkYSide, chunkXSide)
  local o = o or {}
  
  self.chunks = chunks
  self.map = map
  self.chunkYSide = chunkYSide
  self.chunkXSide = chunkXSide
  
  connectSections()
  
  return setmetatable(o, ConnectionMakerMT)
end

-- Public methods
function ConnectionMaker:getChunksAndMapWithConnections()
  return self.chunks, self.map 
  
end

return ConnectionMaker
