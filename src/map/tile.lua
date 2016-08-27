local Tile = class('Tile')

function Tile:initialize(x, y, map)
  self.x = x
  self.y = y
  self.map = map

  self.sprite = Sprite.tiles:newInstance()
    :setAnimation('tundra')
end

function Tile:draw()
  local x = 0
  local y = 0

  x = x + self.x * 16
  y = y - self.x * 8

  x = x + self.y * 16
  y = y + self.y * 8

  -- centre offset
  y = y - 8

  -- lg.setColor((self == game.selectedTile) and COLOR_GRAY or COLOR_WHITE)
  lg.setColor(COLOR_WHITE)
  if self == self.map.selectedTile then
    lg.setColor(COLOR_GRAY)
  end
  self.sprite:draw(x + self.map.offsetX, y + self.map.offsetY)
end

return Tile
