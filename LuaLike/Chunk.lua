--Class
local Chunk = 
{ middleY = 0, 
  middleX = 0,
  middleYRoom = 0, 
  middleXRoom = 0, 
  empty = true}
local ChunkMT = {__index = Chunk}

-- A chunk is basically a dataclass that keeps track of where y and x points are and if it is empty

-- Constructor
function Chunk:new (o, middleY, middleX, middleYRoom, middleXRoom, empty)
  local o = o or {}
  o.middleY = middleY
  o.middleX = middleX
  o.middleYRoom = middleYRoom
  o.middleXRoom = middleXRoom
  o.empty = empty
  return setmetatable(o, ChunkMT)
end

-- Public Methods
function Chunk:getMiddleY ()
  return self.middleY
end

function Chunk:getMiddleX ()
  return self.middleX
end

function Chunk:getMiddleYRoom ()
  return self.middleYRoom
end

function Chunk:getMiddleXRoom ()
  return self.middleXRoom
end

function Chunk:isEmpty ()
  return self.empty
end

return Chunk