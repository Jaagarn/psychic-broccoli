local Draw = require("Draw")

-- Class
local SpecialRoom = 
{ roomHeight = 0, 
  roomWidth = 0, 
  maxRoomHeigth = 0, 
  maxRoomWidth = 0, 
  startingYPoint = 0, 
  startingXPoint = 0, 
  roomMap = {},
  chunkOnY = 0,
  chunkOnX = 0,
  yPathPoint = 0,
  xPathPoint = 0 }
local SpecialRoomMT = {__index = SpecialRoom}

-- Private methods

-- Creates a room map. Special rooms fill out their whole section (-1 y and -1 x for walls)
-- right now just to make them visually distinct from normal rooms which can never fill more than 
-- 80% of the chunk space
local function createRoomMap ()
  
  local roomMap = {}
  for i=1, SpecialRoom.maxRoomHeigth do
    roomMap[i] = {}
    for j=1, SpecialRoom.maxRoomWidth do
      roomMap[i][j] = Draw.MapPixel.EMPTY
    end
  end
  
  for i=SpecialRoom.startingYPoint, SpecialRoom.startingYPoint + SpecialRoom.roomHeight do
    for j=SpecialRoom.startingXPoint, SpecialRoom.startingXPoint + SpecialRoom.roomWidth do
      roomMap[i][j] = Draw.MapPixel.FLOOR
    end
  end

  return roomMap;
  
end

-- Constructor
function SpecialRoom:new (o, maxRoomHeigth, maxRoomWidth, whatKind, chunkOnY, chunkOnX)
  local o = o or {}
  
  self.maxRoomHeigth = maxRoomHeigth
  self.maxRoomWidth = maxRoomWidth
 
  self.roomHeight = maxRoomHeigth-3
  self.roomWidth = maxRoomWidth-3
  
  self.startingYPoint = 2
  self.startingXPoint = 2
  
  self.chunkOnY = chunkOnY
  self.chunkOnX = chunkOnX
  
  self.roomMap = createRoomMap ()
  
  -- Special rooms are placed on special chunks. Right now the one of the corners of the innermost and outermost
  -- sections. With the startingroom being in the innermost and the endingroom being in the othermost.
  -- The yx point is placed depending on with chunk the specialroom will be placed in.
  if(self.chunkOnY == self.chunkOnX) then
    if(self.chunkOnY <= 5) then
      self.yPathPoint = self.startingYPoint+self.roomHeight - 1
      self.xPathPoint = self.startingXPoint+self.roomWidth - 1
    else
      self.yPathPoint = self.startingYPoint
      self.xPathPoint = self.startingXPoint 
    end
  else
    if(self.chunkOnY > self.chunkOnX) then
      self.yPathPoint = self.startingYPoint
      self.xPathPoint = self.startingXPoint+self.roomWidth - 1
    else
      self.yPathPoint = self.startingYPoint+self.roomHeight - 1
      self.xPathPoint = self.startingXPoint
    end
  end
  
  -- The startingroom just have a square of walls in the middle. Sometimes the path- or the connectionmaker
  -- can make a path through this square.
  if(whatKind == Draw.SpecialRoom.STARTINGROOM) then
    local oneThirdroomHeight = math.floor(self.roomHeight/3) 
    local oneThirdroomWidth = math.floor(self.roomWidth/3) 
    for i=self.startingYPoint + oneThirdroomHeight, self.startingYPoint + self.roomHeight - oneThirdroomHeight do
      for j=self.startingXPoint + oneThirdroomWidth, self.startingXPoint + self.roomWidth -  oneThirdroomWidth do
        self.roomMap[i][j] = Draw.MapPixel.WALL
      end
    end
  end
  
  -- The endingroom has an inner sqaure of walls as the starting room, but we use it to create a treasure room
  -- with a closed door to signify that it is the last room.
  if(whatKind == Draw.SpecialRoom.ENDINGROOM) then
    local oneThirdroomHeight = math.floor(self.roomHeight/3) 
    local oneThirdroomWidth = math.floor(self.roomWidth/3) 
    for i=self.startingYPoint + oneThirdroomHeight, self.startingYPoint + self.roomHeight - oneThirdroomHeight do
      for j=self.startingXPoint + oneThirdroomWidth, self.startingXPoint + self.roomWidth -  oneThirdroomWidth do
        self.roomMap[i][j] = Draw.MapPixel.WALL
      end
    end
    self.roomMap[self.startingYPoint + oneThirdroomHeight][self.startingXPoint + oneThirdroomWidth + 1] = Draw.MapPixel.CLOSEDDOOR
    for i=self.startingYPoint + oneThirdroomHeight + 1, self.startingYPoint + self.roomHeight - oneThirdroomHeight - 1 do
      for j=self.startingXPoint + oneThirdroomWidth + 1, self.startingXPoint + self.roomWidth -  oneThirdroomWidth - 1 do
        self.roomMap[i][j] = Draw.MapPixel.GOLDORGEMS
      end
    end
  end
  
  return setmetatable(o, SpecialRoomMT)
end

-- Methods
function SpecialRoom:getRoomMap ()
  return self.roomMap
end

function SpecialRoom:getroomHeight ()
  return self.maxRoomHeigth
end

function SpecialRoom:getroomWidth ()
  return self.maxRoomWidth
end

function SpecialRoom:getAYXPointInRoom ()
  return self.yPathPoint, self.xPathPoint
end

return SpecialRoom