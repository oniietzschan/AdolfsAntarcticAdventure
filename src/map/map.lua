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

  self:clearColors()
  self:clearUnitColors()
end

local maps = {
[[
^^^^.a.^^^
^$......|^
.p.....a..
..p.*.....
..^p..^^^.
.p..$^^^..
.......a..
..p...a...
^....*.^$^
^^..^^^^^^
]],
[[
^^^^^^^^^^
^$....|.^^
.........^
.....^^.a^
..*^...^^^
..^..$^^^^
.....p..p^
......p...
^^........
^^^$^.....
]],
[[
^^^^...^^^
^$......|^
...a......
....*.....
.p^...^^^.
....$^^^..
.......a..
.p........
^....*.^$^
^^..^^^^^^
]],
[[
..........
..........
.pp...pppp
p.......p.
p.......p.
p.pp....p.
p..p..p.p.
 pp....p..
..........
..........
]],
[[
^^^^...^^^
^$.......^
...a.....^
....*...^^
.p^...^^^.
....$^^^..
.....^....
.pp.^^....
^...^^.^|^
^^..^^^^^^
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
      elseif char == 'a' then
        unitClass = Agarthan
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

function Map:update(dt)
  self:selectTile()

  for _, tile in pairs(self.tiles) do
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
  tile:populateDrawOffset()

  self.tiles[x .. ',' .. y] = tile
end

function Map:filterTiles(filter)
  local tiles = {}

  for _, tile in pairs(self.tiles) do
    if filter(tile) == true then
      table.insert(tiles, tile)
    end
  end

  return tiles
end

function Map:getUnit(x, y)
  local tile = self:getTile(x, y)
  if tile == nil then
    error(x, y)
  end

  return tile.unit
end

function Map:setUnit(x, y, unit)
  if unit and unit.tile then
    unit.tile.unit = nil
  end

  local tile = self:getTile(x, y)
  if tile == nil then
    error(x, y)
  end

  tile:setUnit(unit)
end

function Map:filterUnits(filter)
  local units = {}

  for _, tile in pairs(self.tiles) do
    if tile.unit and filter(tile.unit) == true then
      table.insert(units, tile.unit)
    end
  end

  return units
end

function Map:draw()
  for i, drawable in ipairs(self:getSortedDrawables()) do
    drawable:draw()
  end
end

function Map:getSortedDrawables()
  local drawables = {}

  for _, tile in pairs(self.tiles) do
    table.insert(drawables, #drawables + 1, tile)
    if tile.unit then
      table.insert(drawables, #drawables + 1, tile.unit)
    end
    for i, frill in ipairs(tile.frills) do
      table.insert(drawables, #drawables + 1, frill)
    end
  end

  table.sort(drawables, function(a, b)
    local ax, ay = a:getDrawOffset()
    local bx, by = b:getDrawOffset()

    if a:isInstanceOf(Unit) then
      ay = ay + 7.99999
    end
    if b:isInstanceOf(Unit) then
      by = by + 7.99999
    end

    if ay == by then
      return ax > bx
    else
      return ay < by
    end
  end)

  return drawables
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
  for _, tile in pairs(self.tiles) do
    tile:endTurn()

    if tile.unit then
      tile.unit:endTurn()
    end
  end
end

return Map
