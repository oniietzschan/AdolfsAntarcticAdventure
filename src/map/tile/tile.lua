local Tile = class('Tile')

function Tile:initialize()
  self.sprite = Sprite.tiles:newInstance()
    :setAnimation(self:getDefaultAnimation())
end

function Tile:getDefaultAnimation()
  return 'tundra'
end

function Tile:update(dt)
  self.sprite:animate(dt)
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

  lg.setColor((self == self.map.selectedTile) and COLOR_GRAY or COLOR_WHITE)

  self.sprite:draw(x + self.map.offsetX, y + self.map.offsetY)
end

return Tile
