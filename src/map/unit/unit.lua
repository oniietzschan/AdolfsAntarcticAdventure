local C = class('Unit')

function C:initialize()
end

function C:update(dt)
  self.sprite:animate(dt)
end

function C:draw(x, y)
  lg.setColor((self.tile == self.tile.map.selectedTile) and COLOR_HIGHLIGHT_GREY or COLOR_WHITE)

  self.sprite:draw(x, y)
end

function C:isFriendly()
  return self.isFriendly == true
end

function C:getMovementRange()
  return self.movementRange
end

function C:isFlying()
  return self.flying == true
end

function C:hover()
  return {
    name = 'Unit',
    gameplay = 'I wonder what it does?',
  }
end

return C
