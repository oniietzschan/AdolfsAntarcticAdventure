local C = class('Panzer', Unit)

function C:initialize()
  self.sprite = Sprite.panzer:newInstance()

  Unit.initialize(self)

  self.hp = 5
  self.maxHp = 5
  self.friendly = true
  self.movementRange = 3
  self.flying = false
end

function C:getDefaultAnimation()
  return 'active'
end

function C:hover()
  return {
    name = 'Black Order Panzerkampfwagen',
    gameplay = 'Friendly land unit. ' .. self.hp .. ' out of ' .. self.maxHp .. ' hp.',
    flavour = 'A precision-crafted machine designed to destroy Venusian serpent men.',
  }
end

return C
