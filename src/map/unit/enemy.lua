local C = class('Enemy', Unit)

function C:initialize(...)
  Unit.initialize(self)

  self.hp = 5
  self.maxHp = 5
  self.friendly = false
  self.flying = false
end

function C:canMove()
  return true
end

function C:canAttack()
  return true
end

return C
