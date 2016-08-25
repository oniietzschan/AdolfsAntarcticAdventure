local Motion = class('Motion', Component)

function Motion:initialize(t)
  Component.initialize(self, t)

  self.parent.speedX = 0
  self.parent.speedY = 0
end

function Motion:update(dt)
  if self.parent.speedX == 0 and self.parent.speedY == 0 then
    return
  end

  local relX, relY = self.parent.speedX * dt, self.parent.speedY * dt

  local actualX, actualY, cols, len = self.parent:move(relX, relY)

  if len >= 1 then
    if not util.floatsEqual(actualX, relX) and util.sameSign(relX, self.parent.speedX) then
      self.parent.speedX = 0
    end
    if not util.floatsEqual(actualY, relY) and util.sameSign(relY, self.parent.speedY) then
      self.parent.speedY = 0
    end
  end
end

function Motion:remove(msg)
  print(self.parent.class.name .. ' ' .. msg)

  self.parent:remove()
end

return Motion
