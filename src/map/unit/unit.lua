local C = class('Unit')

function C:initialize()
  self:setMoved(false)
end

function C:update(dt)
  self.sprite:animate(dt)
end

function C:draw(x, y)
  local color = (self:isAllowedToMove() == false) and COLOR_HIGHLIGHT_DARK_GREY or COLOR_WHITE

  lg.setColor((self.tile == self.tile.map.selectedTile) and COLOR_HIGHLIGHT_GREY or color)

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

function C:endTurn()
  self:setMoved(false)
end

function C:isAllowedToMove()
  return self.canMove == true
end

function C:setMoved(hasMoved)
  self.canMove = hasMoved == false

  if self.canMove then
    self.sprite
      :setAnimation('active')
      :setAnimationPosition(0)
  else
    self.sprite:setAnimation('stopped')
  end
end

return C
