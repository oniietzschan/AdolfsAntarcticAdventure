local Player = class('Player', Seibutsu)

function Player:initialize(t)
  self.hp = 99
  self.walk_speed_max = PLAYER_WALK_SPEED
  self.walk_acceleration = PLAYER_WALK_ACCELERATION

  t.components = {}

  t.w = 7
  t.h = 12
  t.sprite = Sprite.player
  t.img_offset_x = -4
  t.img_offset_y = -10
  t.img_quad_w = 15
  t.img_quad_h = 22

  Seibutsu.initialize(self, t)
end

function Player:remove()
  Seibutsu.remove(self)
  player = nil
end

function Player:update(dt)
  self:handleWalking(dt)

  Seibutsu.update(self, dt)
end

function Player:handleWalking(dt)
  if Input.down('left') then
    self:walk(true, dt)
  elseif Input.down('right') then
    self:walk(false, dt)
  else
    self:dampenXSpeed(dt)
  end
end

function Player:walk(left, dt)
  self.sprite:setMirrored(left)

  local rel_x_speed = PLAYER_WALK_ACCELERATION * dt
  if left then
    rel_x_speed = rel_x_speed * -1
  end

  self.speedX = self.speedX + rel_x_speed

  -- -- If switching directions, then damping can help us reverse
  -- if (rel_x_speed < 0 and self.speedX > 0) or (rel_x_speed > 0 and self.speedX < 0) then
  --     self:dampenXSpeed(dt)
  -- end

  if math.abs(self.speedX) > PLAYER_WALK_SPEED then
    local sign = util.choose(self.speedX > 0, 1, -1)
    self.speedX = self.walk_speed_max * sign
  end
end

function Player:dampenXSpeed(dt)
  local factor = WALK_DAMPEN_FACTOR
  self.speedX = self.speedX * math.pow(factor, dt)

  if math.abs(self.speedX) < 1 then
    self.speedX = 0
  end
end

function Player.bumpFilter(this, other)
  -- Todo: not a great place for this...
  if other.solid and this.climbing and this.speedY > 0 then
    this.climbing = false
  end

  if other.living then
    return 'bounce'
  elseif other.solid_top and this.climbing then
    return 'cross'
  end

  return Seibutsu.bumpFilter(this, other)
end

return Player
