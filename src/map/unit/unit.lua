local C = class('Unit')

function C:initialize()
  self:setMoved(false)
end

function C:remove()
  self.tile:setUnit(nil)
end

function C:update(dt)
  self.sprite:animate(dt)
end

function C:draw(x, y)
  local color = self.tile.map:getUnitColor(self.tile.x, self.tile.y) or COLOR_WHITE

  if self:isFriendly() and self:isAllowedToMove() == false then
    color = COLOR_HIGHLIGHT_DARK_GREY
  end

  lg.setColor(color)

  self.sprite:draw(x, y)
end

function C:getAttack()
  return self.attack or 0
end

function C:takeDamage(dmg)
  if dmg <= 0 then
    error('damage should be positive')
  end

  self.hp = self.hp - dmg

  if self.hp < 0 then
    self.hp = 0
  end
end

function C:isFriendly()
  return self.friendly == true
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
