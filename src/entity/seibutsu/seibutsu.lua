local Seibutsu = class('Seibutsu', Base)

function Seibutsu:initialize(t)
  t.components = t.components or {}
  Util.tableConcat(t.components, {
    Living,
    Motion,
    Touches,
  })

  Base.initialize(self, t)
end

function Seibutsu:update(dt)
  Base.update(self, dt)

  self.sprite:animate(dt)
end

function Seibutsu.bumpFilter(this, other)
  if other:isInstanceOf(Player) then
    return 'slide'
  end

  return Base.bumpFilter(this, other)
end

function Seibutsu:takeDamage(damage)
  self:event(EVENT_TAKE_DAMAGE, {damage = damage})
end

return Seibutsu
