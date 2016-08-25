local AiPace = class('AiPace', Component)

function AiPace:initialize(t)
  Component.initialize(self, t)

  self.facing_left = false

  if rng() < 0.5 then
    self:reverseDirection()
  end

  -- Randomize animation phase, so that all enemies aren't walking in syncro.
  Timer.after(0.1, function()
    self.parent.sprite:setRandomAnimationPosition()
  end)
end

function AiPace:update(dt)
  -- If stopped, then we hit an obstacle last update, reverse!
  if self.parent.speedX == 0 or self:isAtEndOfPlatform() then
    self:reverseDirection()
  end

  if self.facing_left then
    self.parent.speedX = -self.parent.walk_speed
  else
    self.parent.speedX = self.parent.walk_speed
  end
end

function AiPace:isAtEndOfPlatform()
  local x, y, w, h = self.parent:getRect()

  if self.facing_left then
    x = x - (w * -0.4)
  else
    x = x + (w * 0.6)
  end

  y = y + h + 1

  local items, len = self.parent.world:queryPoint(x, y, filters.solid)

  return len == 0
end

-- Todo: doesn't make sense, see (9)
function AiPace:handleCollision(col)
  if col.other:isInstanceOf(Player) == false then
    return
  end

  if col.other.takeDamage then
    col.other:takeDamage(1)
  end
end

function AiPace:reverseDirection()
  self.facing_left = not self.facing_left
  self.parent.sprite:setMirrored(self.facing_left)
end

return AiPace
