local Frill = class('Frill', BaseFrill)

Frill:include(HasComponents)

function Frill:initialize(t)
  BaseFrill.initialize(self, t)

  self.sprite = t.sprite:newInstance()

  if t.animation then
    local animation = (type(t.animation) == 'table') and Util.sample(t.animation) or t.animation
    self.sprite:setAnimation(animation)

    self.sprite:setRandomAnimationPosition()
  end
end

function Frill:remove()
  self.game.camera:removeFromLayer(self.layer, self)
end

function Frill:update(dt)
  BaseFrill.update(self, dt)

  self.sprite:animate(dt)
end

function Frill:draw()
  self.sprite:draw(self.x + self.offsetX, self.y + self.offsetY)
end

return Frill
