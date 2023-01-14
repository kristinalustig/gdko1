M = {}

local map

function M.init()
  
  map = {}

  for line in love.filesystem.lines("/assets/map.txt") do
    local t = SplitLinesByComma(line)
    table.insert(map, t)
  end

end

function SplitLinesByComma(line)
  
  local values = {}
  for value in line:gmatch("[^,]+") do
    if value:sub(#value, #value) == " " then
      value = value:sub(1, #value-1)
    end
    table.insert(values, value)
  end
  return values
  
end

function M.getMap()
  
  return map
  
end

return M