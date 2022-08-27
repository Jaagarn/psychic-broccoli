local Draw = require("Draw")

-- Class
local PathMaker = 
{ chunks = {}, 
  map = {} }
local PathMakerMT = {__index = PathMaker}

--Private methods

--Gets the a y,x point for a chunk. Which is taken (a point in a room or the middle of the chunk) depends on if the chunk has a room or not.
local function getYXFromChunk(chunk)
  local chunkX = 0
  local chunkY = 0
  
  if(chunk:isEmpty() == true) then
    chunkX = chunk:getMiddleY()
    chunkY = chunk:getMiddleX()
  else
    chunkX = chunk:getMiddleYRoom()
    chunkY = chunk:getMiddleXRoom()
  end
  return chunkX, chunkY
  
end

--Makes a path between two chunks. It makes the path by drawing floor tiles between two points in the chunks.
--If y or x is done first is random for variance
local function makePathBetweenTwoSetsOfChunksYXPoints(firstChunkY, firstChunkX, secondChunkY, secondChunkX)
  
  math.randomseed(firstChunkY * firstChunkX * secondChunkY * secondChunkX * os.time())
  local YOrXFirst = math.random(1, 2)
  
  --Needed if the chunk is empty. 
  PathMaker.map[firstChunkY][firstChunkX] = Draw.MapPixel.FLOOR
  
  if(YOrXFirst == 1) then
    while(firstChunkY ~= secondChunkY) do
      if(firstChunkY > secondChunkY) then
        firstChunkY = firstChunkY - 1
      elseif(firstChunkY < secondChunkY) then
        firstChunkY = firstChunkY + 1
      end
      PathMaker.map[firstChunkY][firstChunkX] = Draw.MapPixel.FLOOR
    end
    while(firstChunkX ~= secondChunkX) do
      if(firstChunkX > secondChunkX) then
        firstChunkX = firstChunkX - 1
      elseif(firstChunkX < secondChunkX) then
        firstChunkX = firstChunkX + 1
      end
      PathMaker.map[firstChunkY][firstChunkX] = Draw.MapPixel.FLOOR
    end
  elseif(YOrXFirst == 2) then
    while(firstChunkY ~= secondChunkY) do
      if(firstChunkY > secondChunkY) then
        firstChunkY = firstChunkY - 1
      elseif(firstChunkY < secondChunkY) then
        firstChunkY = firstChunkY + 1
      end
      PathMaker.map[firstChunkY][firstChunkX] = Draw.MapPixel.FLOOR
    end
    while(firstChunkX ~= secondChunkX) do
      if(firstChunkX > secondChunkX) then
        firstChunkX = firstChunkX - 1
      elseif(firstChunkX < secondChunkX) then
        firstChunkX = firstChunkX + 1
      end
      PathMaker.map[firstChunkY][firstChunkX] = Draw.MapPixel.FLOOR
      
    end
    
  end
  
end

--Connects all chunks in a column in a section, for all columns left of the center
local function addPathsToLeftColumn()
  
  local startY = 5
  local endY = 6
  local startX = 5
  
  while(startY > 0) do
    for i = startY, endY - 1  do
      local firstChunk = PathMaker.chunks[i][startX]
      local secondChunk = PathMaker.chunks[i+1][startX]
    
      local firstChunkY = 0
      local firstChunkX = 0
  
      firstChunkY, firstChunkX = getYXFromChunk(firstChunk)
  
      local secondChunkY = 0
      local secondChunkX = 0
    
      secondChunkY, secondChunkX = getYXFromChunk(secondChunk)
      
      makePathBetweenTwoSetsOfChunksYXPoints(firstChunkY, firstChunkX, secondChunkY, secondChunkX)
      
    end
  endY = endY + 1
  startY = startY - 1
  startX = startX - 1
 
  end
end

--Connects all chunks in a column in a section, for all columns right of the center
local function addPathsToRightColumn()
  
  local startY = 5
  local endY = 6
  local startX = 6
  
  while(startY > 0) do
    for i = startY, endY - 1 do
      local firstChunk = PathMaker.chunks[i][startX]
      local secondChunk = PathMaker.chunks[i+1][startX]
    
      local firstChunkY = 0
      local firstChunkX = 0
  
      firstChunkY, firstChunkX = getYXFromChunk(firstChunk)
  
      local secondChunkY = 0
      local secondChunkX = 0
    
      secondChunkY, secondChunkX = getYXFromChunk(secondChunk)
      
      makePathBetweenTwoSetsOfChunksYXPoints(firstChunkY, firstChunkX, secondChunkY, secondChunkX)
      
    end
  endY = endY + 1
  startY = startY - 1
  startX = startX + 1
  
  end

end

--Connects all chunks in a row in a section, for all columns top of the center
local function addPathsToTopRow()
  
  local startY = 5
  local startX = 5
  local endX = 6
  
  while(startX > 0) do
    for i = startX, endX - 1  do
      local firstChunk = PathMaker.chunks[startY][i]
      local secondChunk = PathMaker.chunks[startY][i+1]
    
      local firstChunkY = 0
      local firstChunkX = 0
  
      firstChunkY, firstChunkX = getYXFromChunk(firstChunk)
  
      local secondChunkY = 0
      local secondChunkX = 0
    
      secondChunkY, secondChunkX = getYXFromChunk(secondChunk)
      
      makePathBetweenTwoSetsOfChunksYXPoints(firstChunkY, firstChunkX, secondChunkY, secondChunkX)
    end
  endX = endX + 1
  startY = startY - 1
  startX = startX - 1
  
  end

end

--Connects all chunks in a row in a section, for all columns below the center
local function addPathsToBottomRow()
  local startY = 6
  local startX = 5
  local endX = 6
  
  while(startX > 0) do
    for i = startX, endX - 1  do
      local firstChunk = PathMaker.chunks[startY][i]
      local secondChunk = PathMaker.chunks[startY][i+1]
    
      local firstChunkY = 0
      local firstChunkX = 0
  
      firstChunkY, firstChunkX = getYXFromChunk(firstChunk)
  
      local secondChunkY = 0
      local secondChunkX = 0
    
      secondChunkY, secondChunkX = getYXFromChunk(secondChunk)
      
      makePathBetweenTwoSetsOfChunksYXPoints(firstChunkY, firstChunkX, secondChunkY, secondChunkX)
    end
  startX = startX - 1
  endX = endX + 1
  startY = startY + 1
  
  end

end

-- Adds paths to each section so that each chunk in a section is connected with two paths to the chunks next
-- to itself. The chunk may have one-to-multiple connections to other sections

local function addPaths()
  
  addPathsToTopRow()
  addPathsToBottomRow()
  addPathsToLeftColumn()
  addPathsToRightColumn()
  
end


-- Constructor
function PathMaker:new (o, chunks, map)
  local o = o or {}
  
  self.chunks = chunks
  self.map = map
  
  addPaths()
  
  return setmetatable(o, PathMakerMT)
end

function PathMaker:getChunksAndMapWithPaths()
  return self.chunks, self.map 
end

return PathMaker