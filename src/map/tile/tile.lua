local C = class('Tile')

function C:initialize()
  self.sprite = Sprite.tiles:newInstance()
    :setAnimation(self:getDefaultAnimation())
end

function C:getDefaultAnimation()
  return 'tundra'
end

function C:update(dt)
  self.sprite:animate(dt)

  if self.unit then
    self.unit:update(dt)
  end
end

function C:draw()
  local x = 0
  local y = 0

  x = x + self.x * 16
  y = y - self.x * 8

  x = x + self.y * 16
  y = y + self.y * 8

  x = x + self.map.offsetX
  y = y + self.map.offsetY

  -- centre offset
  y = y - 8

  self.sprite:draw(x, y)

  if self.unit then
    self.unit:draw(x, y)
  end
end

function C:isPassable()
  return self.impassable ~= true
end

function C:setUnit(unit)
  if self.unit ~= nil then
    error('already has unit!')
  end

  self.unit = unit

  if unit ~= nil then
    unit.tile = self
  end
end

function C:endTurn()
end

function C:hover()
  return {
    name = 'Tundra',
  }
end

return C
