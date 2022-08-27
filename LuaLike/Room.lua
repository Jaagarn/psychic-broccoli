local Draw = require("Draw")
--Room has fixed flipped issue
-- Class
local Room = 
{ roomHeight = 0, 
  roomWidth = 0, 
  maxRoomHeight = 0, 
  maxRoomWidth= 0, 
  startingYPoint = 0, 
  startingXPoint= 0, 
  roomMap = {} }
local RoomMT = {__index = Room}

-- Private methods

-- Creates a room for a chunk and fills the rest of the space with empty tiles.
local function createRoomMap ()
  
  local roomMap = {}
  for i=1, Room.maxRoomHeight do
    roomMap[i] = {}
    for j=1, Room.maxRoomWidth do
      roomMap[i][j] = Draw.MapPixel.EMPTY
    end
  end
  for i=Room.startingYPoint, Room.startingYPoint + Room.roomHeight - 1 do
    for j=Room.startingXPoint, Room.startingXPoint + Room.roomWidth - 1 do
      roomMap[i][j] = Draw.MapPixel.FLOOR
    end
  end
  return roomMap;
end

-- Constructor
function Room:new (o, maxRoomHeight, maxRoomWidth, seed)
  local o = o or {}
  
  math.randomseed(seed)
  
  self.maxRoomHeight = maxRoomHeight
  self.maxRoomWidth= maxRoomWidth
  
  -- Room max- and minsize are choosen randomly
  local randomMinSize = math.random(4, 5)/10
  local randomMaxSize = math.random(6, 8)/10

  self.roomHeight = math.random(math.floor(self.maxRoomHeight*randomMinSize), math.floor(self.maxRoomHeight*randomMaxSize))
  self.roomWidth = math.random(math.floor(self.maxRoomWidth*randomMinSize), math.floor(self.maxRoomWidth*randomMaxSize))
  
  self.startingYPoint = math.random(2, maxRoomHeight-self.roomHeight - 1)
  self.startingXPoint = math.random(2, maxRoomWidth-self.roomWidth - 1)
  
  self.roomMap = createRoomMap ()
  
  return setmetatable(o, RoomMT)
end

-- Public methods
function Room:getRoomMap ()
  return self.roomMap
end

function Room:getRoomHeight ()
  return self.maxRoomHeight
end

function Room:getHeight ()
  return self.maxRoomWidth

end

-- A random y and x are choosen to give some more variance to the path- and connectionmaker
function Room:getAYXPointInRoom ()
  return (math.random(1, self.roomHeight - 2) + self.startingYPoint), (self.startingXPoint + math.random(1, self.roomWidth - 2))
end

return Room