I = {}

--starting x, starting y, quad width, quad height, num rows, num cols, sheet width, sheet height
function I.initSprites(xStart, yStart, w, h, rows, cols, sw, sh)
  local tempTable = {}
  
  for i = 0, rows-1, 1 do
    for j = 0, cols-1, 1 do
      table.insert(tempTable, lg.newQuad(xStart + (j*w), yStart + (i*h), w, h, sw, sh))
    end
  end
  
  return tempTable
  
end

return I