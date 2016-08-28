local C = class('AgarthanMonolith', Enemy)

function C:initialize(...)
  self.sprite = Sprite.agarthanMonolith:newInstance()

  Enemy.initialize(self)

  self.hp = 6
  self.maxHp = 6
  self.movementRange = 0
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

function C:canMove()
  return false
end

function C:canAttack()
  return false
end

return C
