local Map = class('Map')

function Map:initialize()
  self.offsetX = 128
  self.offsetY = 171

  self.tiles = {}
  self.orderedTiles = {}

  for x = 0, MAP_TILES_X - 1 do
    for y = 0, MAP_TILES_Y - 1 do

      local tile = Tile(x, y, self)

      local position = x .. ',' .. y
      self.tiles[position] = tile

      table.insert(self.orderedTiles, #self.orderedTiles + 1, tile)
    end
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

function Map:draw()
  for _, tile in ipairs(self.orderedTiles) do
    tile:draw()
  end
end

return Map
