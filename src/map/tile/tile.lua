local C = class('Tile')

function C:initialize()
  self.sprite = Sprite.tiles:newInstance()
    :setAnimation(self:getDefaultAnimation())

  self.frills = {}
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
  local color = self.map:getColor(self.x, self.y)
  lg.setColor((self == self.map.selectedTile and color == COLOR_WHITE) and COLOR_HIGHLIGHT_GREY or color)

  local x, y = self:getDrawOffset()

  self.sprite:draw(x, y)
end

function C:getDrawOffset()
  return self.drawAtX, self.drawAtY
end

function C:populateDrawOffset()
  local x = self.x * 16
  local y = self.x * -8

  x = x + self.y * 16
  y = y + self.y * 8

  x = x + self.map.offsetX
  y = y + self.map.offsetY

  -- centre offset
  y = y - 8

  self.drawAtX = x
  self.drawAtY = y
end

function C:isPassable()
  return self.impassable ~= true
end

function C:setUnit(unit)
  if unit ~= nil and self.unit ~= nil then
    error('already has unit!')
  end

  self.unit = unit

  if unit ~= nil then
    unit.tile = self
  end
end

function C:addFrill(frill)
  for i, v in ipairs(self.frills) do
    if v == frill then
      error('already within frill...')
    end
  end

  table.insert(self.frills, frill)
end

function C:removeFrill(frill)
  for i, v in ipairs(self.frills) do
    if v == frill then
      table.remove(self.frills, i)
      return self
    end
  end

  error('could not find within frill...')
end

function C:endTurn()
end

function C:hover()
  return {
    name = 'Tundra',
  }
end

return C
