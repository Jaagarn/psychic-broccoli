local Draw = { MapPixel = {} }

-- A "enum" of "pixels" that can be "drawn".
Draw.MapPixel = {WALL = "#", FLOOR = ".", OPENDOOR = "'", CLOSEDDOOR = "+", EMPTY = " ", GOLDORGEMS = "$"}

-- An "enum" of special rooms.
Draw.SpecialRoom = {STARTINGROOM = "1", ENDINGROOM = "2"}

-- I think this might have been one of the first functions I ever did in LUA. It has served me well.
function Draw:printMap(map, totalY, totalX)
  for i = 1,totalY do

    for j = 1,totalX do
      io.write(map[i][j])
    end
    io.flush()
    print()
  end

end

return Draw