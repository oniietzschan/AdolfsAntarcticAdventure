local C = class('Button')

function C:initialize(x, y, t)
  self.x = x
  self.y = y

  t = t or {}
  for k, v in pairs(t) do
    self[k] = v
  end

  self.w, self.h = self.sprite:getDimensions()
end

function C:draw()
  lg.setColor((ui.selectedButton == self) and COLOR_GRAY or COLOR_WHITE)
  lg.draw(self.sprite, self.x, self.y)
end

function C:isMouseOver()
  local rawX, rawY = love.mouse.getPosition()
  local x = (rawX / screen:getScale())
  local y = (rawY / screen:getScale())

  return x >= self.x
     and y >= self.y
     and x <= self.x + self.w
     and y <= self.y + self.h
end

return C
