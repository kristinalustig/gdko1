I = require "inits"
M = require "map"

C = {}

--the following are all extracted from the sprites sheets
local tileSprites
local itemSprites
local playerSprites

--store the quads for each biome + for plants etc.
local biomeOne
local biomeTwo
local biomeThree
local plants
local footPrints

local homeBase
local altBase
local bridge

--other images
local uiOverlay

local mapTable
local tileMap

local TileType
local Biome
local Overlay

local tileSize

local currentPosX
local currentPosY

local scale
local tileSheetWidth
local tileSheetHeight

function C.init()
  
  scale = 1
  tileSheetWidth = 1536
  tileSheetHeight = 1792
  
  TileType = {
    Plain = 1,
    Edge = 2,
    River = 3,
    Lake = 4,
    EdgeCorner = 5,
    BiomeEdge = 6,
    BiomeEdgeCorner = 7,
    BiomeEdgeWater = 8,
    BiomeWaterCorner = 9
  }
  
  Biome = {
    Grass = 1,
    Dark = 2,
    Snow = 3
  }
  
  Overlay = {
    Rock = 1,
    Cliff = 2,
    Tree = 3,
    Item = 4,
    Camp = 5
  }
  
  tileSize = 64
  
  biomeOne = {}
  biomeTwo = {}
  biomeThree = {}
  biomeOne.tiles = {}
  biomeTwo.tiles = {}
  biomeThree.tiles = {}
  plants = {}
  footPrints = {}
  
  uiOverlay = lg.newImage("/assets/ui.png")
  tileSprites = lg.newImage("/assets/tileSprites.png")
  itemSprites = lg.newImage("/assets/overlaySprites.png")
  playerSprites = lg.newImage("/assets/playerSprites.png")
  
  --grass
  biomeOne.tiles.plain = I.initSprites(0, 0, 128, 128, 9, 1, tileSheetWidth, tileSheetHeight)
  biomeOne.tiles.edge = I.initSprites(128, 0, 128, 128, 9, 1, tileSheetWidth, tileSheetHeight)
  biomeOne.tiles.waterStill = I.initSprites(256, 0, 128, 128, 7, 2, tileSheetWidth, tileSheetHeight)
  biomeOne.tiles.waterRunning = I.initSprites(256, 640, 128, 128, 7, 2, tileSheetWidth, tileSheetHeight)
  biomeOne.tiles.corner = I.initSprites(0, 1280, 128, 128, 2, 2, tileSheetWidth, tileSheetHeight)
  biomeOne.tiles.biomeEdge = I.initSprites(0, 1536, 128, 128, 2, 2, tileSheetWidth, tileSheetHeight)
  biomeOne.tiles.waterEdge = I.initSprites(256, 1536, 128, 128, 2, 2, tileSheetWidth, tileSheetHeight)
  biomeOne.cliffs = I.initSprites(1024, 0, 128, 128, 7, 1, 2304, 896)
  biomeOne.rocks = I.initSprites(1408, 0, 128, 128, 7, 1, 2304, 896)
  biomeOne.trees = I.initSprites(1792, 0, 128, 128, 7, 1, 2304, 896)
  
  --dark
  biomeTwo.tiles.plain = I.initSprites(512, 0, 128, 128, 9, 1, tileSheetWidth, tileSheetHeight)
  biomeTwo.tiles.edge = I.initSprites(640, 0, 128, 128, 9, 1, tileSheetWidth, tileSheetHeight)
  biomeTwo.tiles.waterStill = I.initSprites(768, 0, 128, 128, 7, 2, tileSheetWidth, tileSheetHeight)
  biomeTwo.tiles.waterRunning = I.initSprites(768, 640, 128, 128, 7, 2, tileSheetWidth, tileSheetHeight)
  biomeTwo.tiles.corner = I.initSprites(512, 1280, 128, 128, 2, 2, tileSheetWidth, tileSheetHeight)
  biomeTwo.cliffs = I.initSprites(1152, 0, 128, 128, 7, 1, 2304, 896)
  biomeTwo.rocks = I.initSprites(1536, 0, 128, 128, 7, 1, 2304, 896)
  biomeTwo.trees = I.initSprites(1920, 0, 128, 128, 7, 1, 2304, 896)
  
  --snow
  biomeThree.tiles.plain = I.initSprites(1024, 0, 128, 128, 9, 1, tileSheetWidth, tileSheetHeight)
  biomeThree.tiles.edge = I.initSprites(1152, 0, 128, 128, 9, 1, tileSheetWidth, tileSheetHeight)
  biomeThree.tiles.waterStill = I.initSprites(1280, 0, 128, 128, 7, 2, tileSheetWidth, tileSheetHeight)
  biomeThree.tiles.waterRunning = I.initSprites(1280, 640, 128, 128, 7, 2, tileSheetWidth, tileSheetHeight)
  biomeThree.tiles.corner = I.initSprites(1024, 1280, 128, 128, 2, 2, tileSheetWidth, tileSheetHeight)
  biomeThree.cliffs = I.initSprites(1280, 0, 128, 128, 7, 1, 2304, 896)
  biomeThree.rocks = I.initSprites(1664, 0, 128, 128, 7, 1, 2304, 896)
  biomeThree.trees = I.initSprites(2048, 0, 128, 128, 7, 1, 2304, 896)
  
  plants = I.initSprites(0, 0, 128, 128, 7, 8, 2304, 896)
  
  mapTable = M.getMap()
  
  InitTileMap()
  
  currentPosX = 0
  currentPosY = 0

end


function C.draw()
  
  DrawTileMap()
  
end

function InitTileMap()
  
  tileMap = {}
  
  local xLoc = 0
  local yLoc = 0
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
      local overlay = GetOverlay(v1)
      local overlayQuad = nil
      rot, offsetX, offsetY, tileType, biomeEdge = FindTileDir(k, k1, biome, tileType)
      local quad = GetQuad(tileType, biome, biomeEdge)
      if overlay ~= nil then
        overlayQuad, rotO, offsetXO, offsetYO = GetOverlayQuad(overlay, biome, v1, k, k1)
      end
      table.insert(tileMap, {
          x = xLoc + (offsetX*tileSize),
          y = yLoc + (offsetY*tileSize),
          quad = quad,
          rot = rot,
          overlayQuad = overlayQuad,
          ox = xLoc + (offsetXO*tileSize),
          oy = yLoc + (offsetYO*tileSize),
          rotO = rotO,
        })
      xLoc = xLoc + tileSize
    end
    yLoc = yLoc + tileSize
    xLoc = 0
  end
  
end
  



function DrawTileMap()
  
  for k, v in ipairs(tileMap) do
    lg.draw(tileSprites, v.quad, v.x+currentPosX, v.y+currentPosY, v.rot, .5, .5)
    if v.overlayQuad ~= nil then
      lg.draw(itemSprites, v.overlayQuad, v.ox+currentPosX, v.oy+currentPosY, v.rotO, .5, .5)
    end
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

function GetQuad(t, b, be)
  
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
    q = bQuad.tiles.waterRunning[love.math.random(12)]
  elseif t == TileType.Lake then
    q = bQuad.tiles.waterStill[love.math.random(12)]
  elseif t == TileType.Edge then
    q = bQuad.tiles.edge[love.math.random(9)]
  elseif t == TileType.EdgeCorner then
    q = bQuad.tiles.corner[love.math.random(4)]
  elseif t == TileType.BiomeEdge then 
    if be == Biome.Snow then
      q = bQuad.tiles.biomeEdge[2]
    elseif be == Biome.Dark then
      q = bQuad.tiles.biomeEdge[1]
    end
  elseif t == TileType.BiomeEdgeCorner then
    if be == Biome.Snow then
      q = bQuad.tiles.biomeEdge[4]
    elseif be == Biome.Dark then
      q = bQuad.tiles.biomeEdge[3]
    end
  elseif t == TileType.BiomeEdgeWater then
    if be == Biome.Snow then
      q = bQuad.tiles.waterEdge[2]
    elseif be == Biome.Dark then
      q = bQuad.tiles.waterEdge[1]
    end
  elseif t == TileType.BiomeWaterCorner then
    if be == Biome.Snow then
      q = bQuad.tiles.waterEdge[4]
    elseif be == Biome.Dark then
      q = bQuad.tiles.waterEdge[3]
    end
  else
    q = bQuad.tiles.plain[love.math.random(9)]
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
  local offsetX = 0
  local offsetY = 0
  local tileType = t
  local rot = 0
  local biome = b

  --above
  if r ~= 1 then
    if string.find(mapTable[r-1][c], "i") or string.find(mapTable[r-1][c], "l") then
      waterAbove = true -- math.rad(-90), 0, 1
    end
    if biome == Biome.Grass then
      if string.find(mapTable[r-1][c], "s") then
        biomeEdgeAbove = true
        biomeEdge = Biome.Snow
      elseif string.find(mapTable[r-1][c], "d") then
        biomeEdgeAbove = true
        biomeEdge = Biome.Dark
      end
    end
  end
  --below
  if r ~= #mapTable then 
    if string.find(mapTable[r+1][c], "i") or string.find(mapTable[r+1][c], "l") then
      waterBelow = true --return math.rad(90), 1, 0
    end
    if biome == Biome.Grass then
      if string.find(mapTable[r+1][c], "s") then
        biomeEdgeBelow = true
        biomeEdge = Biome.Snow
      elseif string.find(mapTable[r+1][c], "d") then
        biomeEdgeBelow = true
        biomeEdge = Biome.Dark
      end
    end
  end
  --left
  if c ~= 1 then
    if string.find(mapTable[r][c-1], "i") or string.find(mapTable[r][c-1], "l") then
      waterLeft = true -- return math.rad(180), 1, 1
    end
    if biome == Biome.Grass then
      if string.find(mapTable[r][c-1], "s") then
        biomeEdgeLeft = true
        biomeEdge = Biome.Snow
      elseif string.find(mapTable[r][c-1], "d") then
        biomeEdgeLeft = true
        biomeEdge = Biome.Dark
      end
    end
  end
  --right
  if c ~= #mapTable[1] then 
    if string.find(mapTable[r][c+1], "i") or string.find(mapTable[r][c+1], "l") then
      waterRight = true --return 0, 0, 0
    end
    if biome == Biome.Grass then
      if string.find(mapTable[r][c+1], "s") then
        biomeEdgeRight = true
        biomeEdge = Biome.Snow
      elseif string.find(mapTable[r][c+1], "d") then
        biomeEdgeRight = true
        biomeEdge = Biome.Dark
      end
    end
  end
  
  if waterAbove then
    if waterLeft then
      if tileType == TileType.Plain then
        tileType = TileType.EdgeCorner
        rot = math.rad(180)
        offsetX = 1
        offsetY = 1
      end
    elseif waterRight then
      if tileType == TileType.Plain then
        tileType = TileType.EdgeCorner
        rot = math.rad(-90)
        offsetY = 1
      end
    elseif tileType == TileType.Plain then
      tileType = TileType.Edge
      rot = math.rad(-90)
      offsetY = 1
    end
  elseif waterBelow then
    if waterLeft then
      if tileType == TileType.Plain then
        tileType = TileType.EdgeCorner
        rot = math.rad(90)
        offsetX = 1
      end
    elseif WaterRight then
      if tileType == TileType.Plain then
        tileType =TileType.EdgeCorner
      end
    elseif tileType == TileType.Plain then
      tileType = TileType.Edge
      rot = math.rad(90)
      offsetX = 1
    end
  elseif waterLeft then
    if tileType == TileType.Plain then
      tileType = TileType.Edge
      rot = math.rad(180)
      offsetX = 1
      offsetY = 1
    end
  elseif waterRight then
    if tileType == TileType.Plain then
      tileType = TileType.Edge
    end
    
  elseif biomeEdgeAbove then
    if biomeEdgeLeft then
      rot = math.rad(180)
      offsetX = 1
      offsetY = 1
      if tileType == TileType.Plain then
        tileType = TileType.BiomeEdgeCorner
      elseif tileType == TileType.River then
        tileType = TileType.BiomeWaterCorner
      end
    elseif biomeEdgeRight then
      rot = math.rad(-90)
      offsetY = 1
      if tileType == TileType.Plain then
        tileType = TileType.BiomeEdgeCorner
      elseif tileType == TileType.River then
        tileType = TileType.BiomeWaterCorner 
      end
    elseif tileType == TileType.Plain then
      tileType = TileType.BiomeEdge
      rot = math.rad(180)
      offsetY = 1
      offsetX = 1
    elseif tileType == TileType.River then
      tileType = TileType.BiomeWaterEdge
      rot = math.rad(180)
      offsetY = 1
      offsetX = 1
    end
  elseif biomeEdgeBelow then
    if biomeEdgeLeft then
      rot = math.rad(90)
      offsetX = 1
      if tileType == TileType.Plain then
        tileType = TileType.BiomeEdgeCorner
      elseif tileType == TileType.River then
        tileType = TileType.BiomeWaterCorner
      end
    elseif biomeEdgeRight then
      if tileType == TileType.Plain then
        tileType = TileType.BiomeEdgeCorner
      elseif tileType == TileType.River or tileType == TileType.Lake then
        tileType = TileType.BiomeWaterCorner
      end
    elseif tileType == TileType.Plain then
      tileType = TileType.BiomeEdge
    elseif tileType == TileType.River or tileType == TileType.Lake then
      tileType = TileType.BiomeWaterEdge
    end
  elseif biomeEdgeLeft then
    if tileType == TileType.Plain then
      tileType = TileType.BiomeEdge
      rot = math.rad(90)
      offsetX = 1
    elseif tileType == TileType.River or tileType == TileType.Lake then
      tileType = TileType.BiomeWaterCorner
      rot = math.rad(90)
      offsetX = 1
    end
  elseif biomeEdgeRight then
    if tileType == TileType.Plain then
      tileType = TileType.BiomeEdge
      rot = math.rad(-90)
      offsetY = 1
    elseif tileType == TileType.River or tileType == TileType.Lake then
      tileType = TileType.BiomeWaterCorner
      rot = math.rad(-90)
      offsetY = 1
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

  return rot, offsetX, offsetY, tileType, biomeEdge
  
end


function C.keyPressed(key)
  
  if key == "w" then
    currentPosY = currentPosY + tileSize
  elseif key == "a" then
    currentPosX = currentPosX + tileSize
  elseif key == "s" then
    currentPosY = currentPosY - tileSize
  elseif key == "d" then
    currentPosX = currentPosX - tileSize
  end
  
end



return C