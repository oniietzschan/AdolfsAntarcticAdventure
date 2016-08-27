local C = class('Panzer', Unit)

function C:initialize()
  Unit.initialize(self)

  self.hp = 5
  self.maxHp = 5

  self.sprite = Sprite.panzer:newInstance()
    :setAnimation('active')
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
