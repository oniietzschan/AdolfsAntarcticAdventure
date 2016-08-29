local C = class('Unit')

C:include(Color)
C:include(Shake)

function C:initialize()
  if self.getRandomName then
    self.name = self:getRandomName()
  end

  self:colorInit()

  self:setMoved(false)
  self:setAttacked(false)
end

function C:remove()
  self.tile:addFrill(self)
  self.tile:setUnit(nil)
end

function C:update(dt)
  self.sprite:animate(dt)
end

function C:draw()
  local color = self.tile.map:getUnitColor(self.tile.x, self.tile.y) or COLOR_WHITE

  if self:isFriendly() and self:canMove() == false and self:canAttack() == false then
    color = COLOR_HIGHLIGHT_DARK_GREY
  end

  local r, g, b = unpack(color)
  local a = 255

  r, g, b, a = self:colorProcessRgb(r, g, b, a)

  lg.setColor(r, g, b, a)

  local x, y = self:getDrawOffset()

  x = x + self:shakeGetOffset()
  y = y + self:shakeGetOffset()

  self.sprite:draw(x, y)
end

function C:getDrawOffset()
  if self.drawAtX ~= nil and self.drawAtY ~= nil then
    return self.drawAtX, self.drawAtY
  end

  return self.tile:getDrawOffset()
end

function C:getAttack()
  return self.attack or 0
end

function C:getAttackRange()
  return self.attackRange or 1
end


function C:takeDamage(dmg)
  if dmg <= 0 then
    error('damage should be positive')
  end

  self.hp = self.hp - dmg

  self:shake({intensity = 3, duration = 0.6})

  if self.hp < 0 then
    self.hp = 0
  end

  local TIME = 0.6

  Timer.tween(TIME * 0.25, self, {colorR = 2, colorB = 2, colorG = 2}, 'in-cubic')
  Timer.after(TIME * 0.25, function()
    Timer.tween(TIME * 0.25, self, {colorR = 1, colorB = 1, colorG = 1}, 'in-cubic')
  end)

  if self.hp == 0 then
    local tile = self.tile
    Timer.after(TIME, function() tile:removeFrill(self) end)
    Timer.tween(TIME, self, {colorA = 0}, 'in-cubic')

    self:remove()
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
  self:setAttacked(false)
end

function C:canMove()
  return self.hasMoved == false
end

function C:setMoved(hasMoved)
  self.hasMoved = hasMoved

  if self.hasMoved == false then
    self.sprite
      :setAnimation('active')
      :setAnimationPosition(0)
  end
end

function C:canAttack()
  return self.hasAttacked == false
end

function C:setAttacked(hasAttacked)
  self.hasAttacked = hasAttacked

  if self.hasAttacked then
    self.sprite:setAnimation('stopped')
  end
end

return C
