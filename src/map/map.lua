local Map = class('Map')

function Map:initialize()
  self.offsetX = 128
  self.offsetY = 171

  self.tiles = {}

  for x = 0, MAP_TILES_X - 1 do
    for y = 0, MAP_TILES_Y - 1 do

      local tile = Tile(self)

      self.tiles[pos(x, y)] = tile

      self:setTile(x, y, tile)
    end
  end

  self:load()

  self:storeOrderedTiles()

  self:clearColors()
  self:clearUnitColors()
end

local maps = {
-- [[
-- ^^^^..pppp
-- ^^....*...
-- ......^.^^
-- ..p...^p^.
-- ..^...^^^.
-- ....^^^^..
-- .p...pppp.
-- ..........
-- ^...p*.^^^
-- ^^..^^^^^^
-- ]],
[[
^^^^...^^^
^$....p.|^
..........
..p.*.....
..^...^^^.
....$^^^..
....p.....
..........
^....*.^$^
^^..^^^^^^
]],
[[
^^^^^^^^^^
^$....p.|^
^........^
^..p.*...^
^..^...^^^
^....$^^^^
^....p...^
^........^
^....*.^$^
^^^^^^^^^^
]],
[[
..........
..........
.pp..pppp.
p......p..
p......p..
p.pp...p..
p..p.p.p..
 pp...p...
..........
..........
]],
}

function Map:load()
  local y = 0

  local mapData = maps[game.currentMap]

  for line in string.gmatch(mapData, "(.-)\n") do
    for x = 0, #line - 1 do
      local char = line:sub(x + 1, x + 1)

      local class, unitClass = nil, nil

      if     char == '^' then
        class = Mountain
      elseif char == '$' then
        class = SteelMountain
      elseif char == '*' then
        class = Crystal
      elseif char == '|' then
        unitClass = AgarthanMonolith
      elseif char == 'p' then
        unitClass = Panzer
      end

      if class then
        local tile = class(self)
        self:setTile(x, y, tile)
      end

      if unitClass then
        local unit = unitClass(self)
        self:setUnit(x, y, unit)
      end
    end

    y = y + 1
  end
end

function Map:storeOrderedTiles()
  self.orderedTiles = {}

  for _, tile in pairs(self.tiles) do
    table.insert(self.orderedTiles, #self.orderedTiles + 1, tile)
  end

  table.sort(self.orderedTiles, function(a, b)
    if a.x == b.x then
      return a.y < b.y
    else
      return a.x > b.x
    end
  end)
end

function Map:update(dt)
  self:selectTile()

  for _, tile in ipairs(self.orderedTiles) do
    tile:update(dt)
  end
end

function Map:selectTile()
  local rawX, rawY = love.mouse.getPosition()
  local x = (rawX / screen:getScale())
  local y = (rawY / screen:getScale())
  x = x - self.offsetX
  y = y - self.offsetY

  local tileX = math.floor((x / TILE_W) - (y / TILE_H))
  local tileY = math.floor((x / TILE_W) + (y / TILE_H))

  self.selectedTile = self:getTile(tileX, tileY)
end

function Map:getTile(x, y)
  if x < 0 or y < 0 or x >= MAP_TILES_X or y >= MAP_TILES_Y then
    return nil
  end

  return self.tiles[x .. ',' .. y]
end

function Map:setTile(x, y, tile)
  if x < 0 or y < 0 or x >= MAP_TILES_X or y >= MAP_TILES_Y then
    error(x, y)
  end

  tile.map = self
  tile.x = x
  tile.y = y

  self.tiles[x .. ',' .. y] = tile
end

function Map:getUnit(x, y)
  local tile = self:getTile(x, y)
  if tile == nil then
    error(x, y)
  end

  return tile.unit
end

function Map:setUnit(x, y, unit)
  local tile = self:getTile(x, y)
  if tile == nil then
    error(x, y)
  end

  tile:setUnit(unit)
end

function Map:draw()
  for _, tile in ipairs(self.orderedTiles) do
    local color = self:getColor(tile.x, tile.y)

    lg.setColor((tile == self.selectedTile) and COLOR_HIGHLIGHT_GREY or color)

    tile:draw()
  end
end

function Map:getColor(x, y)
  return self.tileColors[pos(x, y)] or COLOR_WHITE
end

function Map:setColor(x, y, color)
  self.tileColors[pos(x, y)] = color
end

function Map:getUnitColor(x, y)
  return self.unitColors[pos(x, y)] or COLOR_WHITE
end

function Map:setUnitColor(x, y, color)
  self.unitColors[pos(x, y)] = color
end

function Map:clearColors()
  self.tileColors = {}
end

function Map:clearUnitColors()
  self.unitColors = {}
end

function Map:endTurn()
  for _, tile in ipairs(self.orderedTiles) do
    tile:endTurn()

    if tile.unit then
      tile.unit:endTurn()
    end
  end
end

return Map
