local C = class('AgartanMonolith', Unit)

function C:initialize(...)
  self.sprite = Sprite.agarthanMonolith:newInstance()

  Unit.initialize(self)

  self.hp = 5
  self.maxHp = 5
  self.friendly = false
  self.movementRange = 0
  self.flying = false
end

function C:remove()
  Unit.remove(self)

  print('game.mapFinished = true')
  game.mapFinished = true
end

function C:hover()
  return {
    name = 'Agarthan Polar Monolith',
    gameplay = 'Destroy this to proceed.',
    flavour = "An obsidian obelisk with the power to shift the poles of the Earth.",
  }
end

return C
