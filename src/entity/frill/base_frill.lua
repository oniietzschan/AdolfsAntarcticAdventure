local BaseFrill = class('BaseFrill')

function BaseFrill:initialize(t)
  t = t or {}

  self.parent = t.parent
  self.game = self.parent.game

  self.layer = t.layer or 'entity'

  self.offsetX = t.offsetX or 0
  self.offsetY = t.offsetY or 0

  if t.varianceX then
    self.offsetX = self.offsetX + t.varianceX - rng(t.varianceX * 2)
  end

  self.visibleX1 = t.visibleX1 or 0
  self.visibleX2 = t.visibleX2 or 16
  self.visibleY1 = t.visibleY1 or 0
  self.visibleY2 = t.visibleY2 or 16

  self:updatePosition()
end

function BaseFrill:update(dt)
  self:updatePosition()
end

function BaseFrill:updatePosition()
  if self.parent then
    self.x, self.y = self.parent:getRect()
  end
end

function BaseFrill:isVisible(camX, camY, camW, camH)
  local x1 = self.x + self.offsetX + self.visibleX1
  local x2 = self.x + self.offsetX + self.visibleX2
  local y1 = self.y + self.offsetY + self.visibleY1
  local y2 = self.y + self.offsetY + self.visibleY2

  return x2 > camX
     and y2 > camY
     and x1 < camX + camW
     and y1 < camY + camH
end

return BaseFrill
