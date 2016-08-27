local C = class('Unit')

function C:initialize()
end

function C:update(dt)
  self.sprite:animate(dt)
end

function C:draw(x, y)
  self.sprite:draw(x, y)
end

function C:hover()
  return {
    name = 'Unit',
    gameplay = 'I wonder what it does?',
  }
end

return C
