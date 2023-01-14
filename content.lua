I = require "inits"
M = require "map"

C = {}

--the following are all extracted from the sprites sheets
local tileSprites
local itemSprites
local playerSprites
local edgeSprites

--store the quads for each biome + for plants etc.
local biomeOne
local biomeTwo
local biomeThree
local plants
local footPrints
local playerQuads

local homeBase
local altBase
local bridge

--other images
local uiOverlay

local mapTable
local tileMap
local dataMap

local TileType
local Biome
local Overlay
local Edge

local tileSize

local currentPosX
local currentPosY

local scale
local tileSheetWidth
local tileSheetHeight

local px
local py
local onTile

function C.init()
  
  scale = 1
  tileSheetWidth = 1536
  tileSheetHeight = 1280
  edgeSheetWidth = 768
  edgeSheetHeight = 1152
  
  TileType = {
    Plain = 1,
    River = 2,
    Lake = 3
  }
  
  Biome = {
    Grass = 1,
    Dark = 2,
    Snow = 3
  }
  
  Edge = {
    Top = 1,
    Left = 2,
    Right = 3,
    Bottom = 4
  }
  
  Overlay = {
    Rock = 1,
    Cliff = 2,
    Tree = 3,
    Item = 4,
    Camp = 5
  }
  
  tileSize = 64 * (scale*2)
  
  biomeOne = {}
  biomeTwo = {}
  biomeThree = {}
  biomeOne.tiles = {}
  biomeOne.tiles.dark = {}
  biomeOne.tiles.snow = {}
  biomeTwo.tiles = {}
  biomeThree.tiles = {}
  plants = {}
  footPrints = {}
  playerQuads = {}
  
  uiOverlay = lg.newImage("/assets/ui.png")
  tileSprites = lg.newImage("/assets/tileSprites.png")
  itemSprites = lg.newImage("/assets/overlaySprites.png")
  playerSprites = lg.newImage("/assets/playerSprites.png")
  edgeSprites = lg.newImage("/assets/edgeSprites.png")
  
  --grass
  biomeOne.tiles.plain = I.initSprites(0, 0, 128, 128, 9, 2, tileSheetWidth, tileSheetHeight)
  biomeOne.tiles.waterStill = I.initSprites(256, 0, 128, 128, 5, 2, tileSheetWidth, tileSheetHeight)
  biomeOne.tiles.waterRunning = I.initSprites(256, 640, 128, 128, 6, 2, tileSheetWidth, tileSheetHeight)
  biomeOne.tiles.edgeWater = I.initSprites(0, 256, 128, 128, 4, 2, edgeSheetWidth, edgeSheetHeight)
  biomeOne.tiles.edgeWaterCorner = I.initSprites(0, 0, 128, 128, 2, 2, edgeSheetWidth, edgeSheetHeight)
  biomeOne.tiles.dark.edge = I.initSprites(0, 768, 128, 128, 2, 2, edgeSheetWidth, edgeSheetHeight)
  biomeOne.tiles.snow.edge = I.initSprites(256, 768, 128, 128, 2, 2, edgeSheetWidth, edgeSheetHeight)
  biomeOne.tiles.dark.edgeWater = I.initSprites(640, 768, 128, 128, 3, 1, edgeSheetWidth, edgeSheetHeight)
  biomeOne.tiles.snow.edgeWater = I.initSprites(512, 768, 128, 128, 3, 1, edgeSheetWidth, edgeSheetHeight)
  biomeOne.cliffs = I.initSprites(1024, 0, 128, 128, 7, 1, 2304, 896)
  biomeOne.rocks = I.initSprites(1408, 0, 128, 128, 7, 1, 2304, 896)
  biomeOne.trees = I.initSprites(1792, 0, 128, 128, 7, 1, 2304, 896)
  
  --dark
  biomeTwo.tiles.plain = I.initSprites(512, 0, 128, 128, 9, 2, tileSheetWidth, tileSheetHeight)
  biomeTwo.tiles.waterStill = I.initSprites(768, 0, 128, 128, 5, 2, tileSheetWidth, tileSheetHeight)
  biomeTwo.tiles.waterRunning = I.initSprites(768, 640, 128, 128, 6, 2, tileSheetWidth, tileSheetHeight)
  biomeTwo.tiles.edgeWater = I.initSprites(384, 256, 128, 128, 4, 2, edgeSheetWidth, edgeSheetHeight)
  biomeTwo.tiles.edgeWaterCorner = I.initSprites(384, 0, 128, 128, 2, 2, edgeSheetWidth, edgeSheetHeight)
  biomeTwo.cliffs = I.initSprites(1152, 0, 128, 128, 7, 1, 2304, 896)
  biomeTwo.rocks = I.initSprites(1536, 0, 128, 128, 7, 1, 2304, 896)
  biomeTwo.trees = I.initSprites(1920, 0, 128, 128, 7, 1, 2304, 896)
  
  --snow
  biomeThree.tiles.plain = I.initSprites(1024, 0, 128, 128, 9, 2, tileSheetWidth, tileSheetHeight)
  biomeThree.tiles.waterStill = I.initSprites(1280, 0, 128, 128, 6, 2, tileSheetWidth, tileSheetHeight)
  biomeThree.tiles.waterRunning = I.initSprites(1280, 640, 128, 128, 6, 2, tileSheetWidth, tileSheetHeight)
  biomeThree.tiles.edgeWater = I.initSprites(512, 256, 128, 128, 4, 2, edgeSheetWidth, edgeSheetHeight)
  biomeThree.tiles.edgeWaterCorner = I.initSprites(512, 0, 128, 128, 2, 2, edgeSheetWidth, edgeSheetHeight)
  biomeThree.cliffs = I.initSprites(1280, 0, 128, 128, 7, 1, 2304, 896)
  biomeThree.rocks = I.initSprites(1664, 0, 128, 128, 7, 1, 2304, 896)
  biomeThree.trees = I.initSprites(2048, 0, 128, 128, 7, 1, 2304, 896)
  
  plants = I.initSprites(0, 0, 128, 128, 7, 8, 2304, 896)
  
  playerQuads = I.initSprites(0, 0, 76, 136, 2, 4, 304, 272)
  
  mapTable = M.getMap()
  
  InitTileMap()
  
  currentPosX = -2688
  currentPosY = -2816
  
  px = love.graphics.getWidth()/2 - 110
  py = love.graphics.getHeight()/2-(136/2)
  currentTileId = 1224

end


function C.draw()
  
  DrawTileMap()
  DrawPlayer()
  lg.draw(uiOverlay, 0, 0, 0, .5, .5)
  
end

function InitTileMap()
  
  tileMap = {}
  dataMap = {}
  
  local xLoc = 0
  local yLoc = 0
  local id = 1
  for k, v in ipairs(mapTable) do
    for k1, v1 in ipairs(v) do
      local tileType = FindTileType(v1)
      local biome = FindBiome(v1)
      local rot = nil
      local rotO = nil
      local offsetX = 0
      local offsetXO = 0
      local offsetY = 0
      local offsetYO = 0
      local biomeEdge = nil
      local edges = {}
      local overlay = GetOverlay(v1)
      local overlayQuad = nil
      local canWalk = false
      rot, offsetX, offsetY, tileType, edges = FindTileDir(k, k1, biome, tileType)
      local quad = GetQuad(tileType, biome)
      if overlay ~= nil then
        overlayQuad, rotO, offsetXO, offsetYO = GetOverlayQuad(overlay, biome, v1, k, k1)
      end
      local edgeQuads = FindEdgeQuads(edges, tileType, biome)
      if tileType == TileType.Plain and overlay ~= Overlay.Rock and overlay ~= Overlay.Cliff and overlay ~= Overlay.Tree then
        canWalk = true
      end
      table.insert(tileMap, {
          id = id,
          x = xLoc,
          y = yLoc,
          offsetX = offsetX,
          offsetY = offsetY,
          quad = quad,
          rot = rot,
          overlayQuad = overlayQuad,
          ox = xLoc + (offsetXO*tileSize),
          oy = yLoc + (offsetYO*tileSize),
          rotO = rotO,
          edges = edgeQuads
        })
      table.insert(dataMap, {
          id = id,
          r = k,
          c = k1,
          canWalk = canWalk
          })
      xLoc = xLoc + tileSize
      id = id + 1
    end
    yLoc = yLoc + tileSize
    xLoc = 0
  end
  
end
  

function DrawPlayer()
  
  lg.draw(playerSprites, playerQuads[1], px, py, 0, scale, scale)
  
end

function DrawTileMap()
  
  for k, v in ipairs(tileMap) do
    lg.draw(tileSprites, v.quad, v.x+(v.offsetX*tileSize)+currentPosX, v.y+(v.offsetY*tileSize)+currentPosY, v.rot, scale, scale)
    for k1, v1 in ipairs(v.edges) do
      lg.draw(edgeSprites, v1.quad, v.x+currentPosX+(v1.ox*tileSize), v.y+currentPosY+(v1.oy*tileSize), v1.rot, scale, scale)
    end
    if v.overlayQuad ~= nil then
      lg.draw(itemSprites, v.overlayQuad, v.ox+currentPosX, v.oy+currentPosY, v.rotO, scale, scale)
    end
  end
  
end

function FindEdgeQuads(e, t, biome)
  
  local edgeQuads = {}
  local rot = 0
  local ox = 0
  local oy = 0
  local tileType = t
  local corner = false
  local foundWater = true
  local b = biome
  
  --water
  --topleft
  if tileType == TileType.Plain then
    if e.wt and e.wl then
      rot = math.rad(180)
      ox = 1
      oy = 1
      corner = true
      if e.btt ~= nil then
        b = e.btt
      end
    --topright
    elseif e.wt and e.wr then
      rot = math.rad(-90)
      oy = 1
      corner = true
      if e.btt ~= nil then
        b = e.btt
      end
    --bottomleft
    elseif e.wb and e.wl then
      rot = math.rad(90)
      ox = 1
      corner = true
      if e.bbt ~= nil then
        b = e.bbt
      end
    --bottomright
    elseif e.wb and e.wr then
      corner = true
      if e.bbt ~= nil then
        b = e.bbt
      end
    --top
    elseif e.wt then
      rot = math.rad(-90)
      oy = 1
      if e.btt ~= nil then
        b = e.btt
      end
    --bottom
    elseif e.wb then
      rot = math.rad(90)
      ox = 1
      if e.bbt ~= nil then
        b = e.bbt
      end
    --left
    elseif e.wl then
      rot = math.rad(180)
      ox = 1
      oy = 1
      if e.blt ~= nil then
        b = e.blt
      end
    --right
    elseif e.wr then
      if e.brt ~= nil then
        b = e.brt
      end
    else
      foundWater = false
    end
    
    local bQuad = GetBiomeTable(b)
    
    local q = nil
    if foundWater and corner then
      q = bQuad.tiles.edgeWaterCorner[love.math.random(4)]
    elseif foundWater then
      q = bQuad.tiles.edgeWater[love.math.random(8)]
    end
    
    if q ~= nil then
      table.insert(edgeQuads, {
          quad = q,
          rot = rot,
          ox = ox,
          oy = oy})
    end
  end
  
  if biome == Biome.Grass then
    if tileType == TileType.Plain then
      if e.bt and not e.wt then
        table.insert(edgeQuads, {
          quad = GetBiomeEdgeType(e.btt).edge[love.math.random(4)],
          rot = math.rad(-90),
          ox = 0,
          oy = 1
          })
      end
      if e.bl and not e.wl then
        table.insert(edgeQuads, {
          quad = GetBiomeEdgeType(e.blt).edge[love.math.random(4)],
          rot = math.rad(180),
          ox = 1,
          oy = 1
          })
      end
      if e.br and not e.wr then
        table.insert(edgeQuads, {
          quad = GetBiomeEdgeType(e.brt).edge[love.math.random(4)],
          rot = 0,
          ox = 0,
          oy = 0
          })
      end
      if e.bb and not e.wb then
        table.insert(edgeQuads, {
          quad = GetBiomeEdgeType(e.bbt).edge[love.math.random(4)],
          rot = math.rad(90),
          ox = 1,
          oy = 0
          })
      end
    else
      if e.bt and e.wt then
        table.insert(edgeQuads, {
          quad = GetBiomeEdgeType(e.btt).edgeWater[love.math.random(3)],
          rot = math.rad(-90),
          ox = 0,
          oy = 1
          })
      end
      if e.bl and e.wl then
        table.insert(edgeQuads, {
          quad = GetBiomeEdgeType(e.blt).edgeWater[love.math.random(3)],
          rot = math.rad(180),
          ox = 1,
          oy = 1
          })
      end
      if e.br and e.wr then
        table.insert(edgeQuads, {
          quad = GetBiomeEdgeType(e.brt).edgeWater[love.math.random(3)],
          rot = 0,
          ox = 0,
          oy = 0
          })
      end
      if e.bb and e.wb then
        table.insert(edgeQuads, {
          quad = GetBiomeEdgeType(e.bbt).edgeWater[love.math.random(3)],
          rot = math.rad(90),
          ox = 1,
          oy = 0
          })
      end
    end
  end
  
  return edgeQuads
  
end

function GetBiomeTable(b)
  
  if b == Biome.Snow then
    return biomeThree
  elseif b == Biome.Dark then
    return biomeTwo
  else
    return biomeOne
  end
  
end

function GetBiomeEdgeType(b)
  
  if b == Biome.Snow then
    return biomeOne.tiles.snow
  elseif b == Biome.Dark then
    return biomeOne.tiles.dark
  end
  
end


function GetOverlay(s)
  
  if string.find(s, "r") then
    return Overlay.Rock
  elseif string.find(s, "p") then
    return Overlay.Item
  elseif string.find(s, "t") then
    return Overlay.Tree
  elseif string.find(s, "x") then
    return Overlay.Cliff
  end
  
  return nil
  
end

function GetOverlayQuad(o, b, s, r, c)
  
  local overlayQuad = nil
  local rot = 0
  local offsetX = 0
  local offsetY = 0
  local cliffNum = 0
  local bQuad = {}
    
  if b == Biome.Snow then
    bQuad = biomeThree
  elseif b == Biome.Dark then
    bQuad = biomeTwo
  else
    bQuad = biomeOne
  end
  
  if o == Overlay.Cliff then
    rot, offsetX, offsetY, cliffNum = GetCliffQuadNum(r, c)
    overlayQuad = bQuad.cliffs[cliffNum]
  elseif o == Overlay.Rock then
    overlayQuad = bQuad.rocks[love.math.random(7)]
  elseif o == Overlay.Tree then
    overlayQuad = bQuad.trees[love.math.random(7)]
  elseif o == Overlay.Item then
    overlayQuad = GetItem(s)
  end
  
  --return overlayQ, rot, offsetX, offsetY
  return overlayQuad, rot, offsetX, offsetY
  
end

function GetCliffQuadNum(r, c)
  
  if (r == 1 and c == 1) or (r == 1 and c == #mapTable[1]) or (r == #mapTable and c == 1 ) or (r == #mapTable and c == #mapTable[1]) then
    return 0, 0, 0, 7
  elseif c == 1 then
    if string.find(mapTable[r-1][c], "t") or string.find(mapTable[r-1][c], "i") or string.find(mapTable[r-1][c], "r") then
      return 0, 0, 0, 1
    elseif string.find(mapTable[r+1][c], "t") or string.find(mapTable[r+1][c], "i") or string.find(mapTable[r+1][c], "r") then
      return 0, 0, 0, 6
    end
    return 0, 0, 0, math.random(2, 5)
  elseif r == 1 then
    local rot = math.rad(90)
    local ox = 1
    local oy = 0
    if string.find(mapTable[r][c-1], "t") or string.find(mapTable[r][c-1], "i") or string.find(mapTable[r][c-1], "r") then
      return rot, ox, oy, 6
    elseif string.find(mapTable[r][c+1], "t") or string.find(mapTable[r][c+1], "i") or string.find(mapTable[r][c+1], "r") then
      return rot, ox, oy, 1
    end
    return rot, ox, oy, math.random(2, 5)
  elseif c == #mapTable then
    local rot = math.rad(180)
    local ox = 1
    local oy = 1
    if string.find(mapTable[r-1][c], "t") or string.find(mapTable[r-1][c], "i") or string.find(mapTable[r-1][c], "r") then
      return rot, ox, oy, 6
    elseif string.find(mapTable[r+1][c], "t") or string.find(mapTable[r+1][c], "i") or string.find(mapTable[r+1][c], "r") then
      return rot, ox, oy, 1
    end
    return rot, ox, oy, math.random(2, 5)
  elseif r == #mapTable then
    local rot = math.rad(-90)
    local ox = 0
    local oy = 1
    if string.find(mapTable[r][c-1], "t") or string.find(mapTable[r][c-1], "i") or string.find(mapTable[r][c-1], "r")then
      return rot, ox, oy, 1
    elseif string.find(mapTable[r][c+1], "t") or string.find(mapTable[r][c+1], "i") or string.find(mapTable[r][c+1], "r") then
      return rot, ox, oy, 6
    end
    return rot, ox, oy, math.random(2, 5)
  end
  
end

function GetItem(s)
  
  local plantNum = string.sub(s, 1, string.find(s, "p")-1)
  return plants[((plantNum-1)*4)+1]
  
end

function GetQuad(t, b)
  
  local bQuad = {}
  local q = {}
  
  if b == Biome.Snow then
    bQuad = biomeThree
  elseif b == Biome.Dark then
    bQuad = biomeTwo
  else
    bQuad = biomeOne
  end
  
  if t == TileType.River then
    q = bQuad.tiles.waterRunning[love.math.random(#bQuad.tiles.waterRunning)]
  elseif t == TileType.Lake then
    q = bQuad.tiles.waterStill[love.math.random(#bQuad.tiles.waterStill)]
  else
    q = bQuad.tiles.plain[love.math.random(#bQuad.tiles.plain)]
  end
  
  return q
  
end


function FindTileType(s)
  
  if string.find(s, "i") then
    return TileType.River
  elseif string.find(s, "l") then
    return TileType.Lake
  else
    return TileType.Plain
  end
  
end

function FindBiome(s)
  
  if string.find(s, "s") then
    return Biome.Snow
  elseif string.find(s, "d") then
    return Biome.Dark 
  else
    return Biome.Grass
  end
  
end

function FindTileDir(r, c, b, t)
  
  local waterAbove = false
  local waterBelow = false
  local waterLeft = false
  local waterRight = false
  local biomeEdge = nil
  local biomeEdgeLeft = false
  local biomeEdgeRight = false
  local biomeEdgeAbove = false
  local biomeEdgeBelow = false
  local biomeEdgeLeftType = nil
  local biomeEdgeRightType = nil
  local biomeEdgeAboveType = nil
  local biomeEdgeBelowType = nil
  local offsetX = 0
  local offsetY = 0
  local tileType = t
  local rot = 0
  local biome = b
  local edges = {}

  --above
  if r ~= 1 then
    if string.find(mapTable[r-1][c], "i") or string.find(mapTable[r-1][c], "l") then
      waterAbove = true
    end
    if string.find(mapTable[r-1][c], "s") then
      biomeEdgeAbove = true
      biomeEdgeAboveType = Biome.Snow
    elseif string.find(mapTable[r-1][c], "d") then
      biomeEdgeAbove = true
      biomeEdgeAboveType = Biome.Dark
    end
  end
  --below
  if r ~= #mapTable then 
    if string.find(mapTable[r+1][c], "i") or string.find(mapTable[r+1][c], "l") then
      waterBelow = true
    end
    if string.find(mapTable[r+1][c], "s") then
      biomeEdgeBelow = true
      biomeEdgeBelowType = Biome.Snow
    elseif string.find(mapTable[r+1][c], "d") then
      biomeEdgeBelow = true
      biomeEdgeBelowType = Biome.Dark
    end
  end
  --left
  if c ~= 1 then
    if string.find(mapTable[r][c-1], "i") or string.find(mapTable[r][c-1], "l") then
      waterLeft = true
    end
    if string.find(mapTable[r][c-1], "s") then
      biomeEdgeLeft = true
      biomeEdgeLeftType = Biome.Snow
    elseif string.find(mapTable[r][c-1], "d") then
      biomeEdgeLeft = true
      biomeEdgeLeftType = Biome.Dark
    end
  end
  --right
  if c ~= #mapTable[1] then 
    if string.find(mapTable[r][c+1], "i") or string.find(mapTable[r][c+1], "l") then
      waterRight = true
    end
    if string.find(mapTable[r][c+1], "s") then
      biomeEdgeRight = true
      biomeEdgeRightType = Biome.Snow
    elseif string.find(mapTable[r][c+1], "d") then
      biomeEdgeRight = true
      biomeEdgeRightType = Biome.Dark
    end
  end
  
  local dirs = {
    {math.rad(180), 1, 1},
    {math.rad(-90), 0, 1},
    {math.rad(90), 1, 0},
    {0, 0, 0}}
  
  if tileType == TileType.Plain then
    local rand = love.math.random(4)
    rot = dirs[rand][1]
    offsetX = dirs[rand][2]
    offsetY = dirs[rand][3]
  end
  
  edges = 
  {
    wl = waterLeft,
    wr = waterRight,
    wt = waterAbove,
    wb = waterBelow,
    bl = biomeEdgeLeft,
    blt = biomeEdgeLeftType,
    br = biomeEdgeRight,
    brt = biomeEdgeRightType,
    bt = biomeEdgeAbove,
    btt = biomeEdgeAboveType,
    bb = biomeEdgeBelow,
    bbt = biomeEdgeBelowType
  }

  return rot, offsetX, offsetY, tileType, edges
  
end



function CheckCanWalk(id)
  
  return dataMap[id].canWalk
  
end

function ExecuteAction(id)
  
  local dTile = dataMap[id]
  local s = mapTable[dTile.r][dTile.c]
  if string.find(s, "p") then
    local plant = string.sub(s, 1, string.find(s, "p")-1)
    print(plant)
  end
  
end

--function GetPlantInfo(id)

function C.keyPressed(key)
  
  if key == "w" and CheckCanWalk(currentTileId - 50) then
    currentPosY = currentPosY + tileSize
    currentTileId = currentTileId - 50
    ExecuteAction(currentTileId)
  elseif key == "a" and CheckCanWalk(currentTileId - 1) then
    currentPosX = currentPosX + tileSize
    currentTileId = currentTileId - 1
  elseif key == "s" and CheckCanWalk(currentTileId + 50) then
    currentPosY = currentPosY - tileSize
    currentTileId = currentTileId + 50
  elseif key == "d" and CheckCanWalk(currentTileId + 1) then
    currentPosX = currentPosX - tileSize
    currentTileId = currentTileId + 1
  end
  
end



return C