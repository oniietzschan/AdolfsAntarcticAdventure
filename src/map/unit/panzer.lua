local C = class('Panzer', Unit)

function C:initialize()
  self.sprite = Sprite.panzer:newInstance()

  Unit.initialize(self)

  self.hp = 5
  self.maxHp = 5
  self.attack = 3
  self.friendly = true
  self.movementRange = 3
  self.flying = false
end

function C:hover()
  return {
    name = 'Black Order Panzerkampfwagen',
    gameplay = 'Friendly land unit.',
    flavour = 'A precision-crafted machine designed to destroy Venusian serpent men.',
  }
end

return C
