local Base = class('Base')

Base:include(HasComponents)

function Base:initialize(t)
  local x = t.x or 0
  local y = t.y or 0
  local w = t.w or 16
  local h = t.h or 16

  if t.varianceX then
    x = x + t.varianceX - rng(t.varianceX * 2)
  end
  x = math.floor(x + 0.5)
  y = math.floor(y + 0.5)

  self.solid = t.solid or false
  self.solid_top = t.solid_top or false

  self.layer = t.layer or 'entity'

  self.sprite = t.sprite:newInstance()
  self.drawOffsetX = t.drawOffsetX or 0
  self.drawOffsetY = t.drawOffsetY or 0

  if t.animation then
    local animation = (type(t.animation) == 'table') and Util.sample(t.animation) or t.animation
    self.sprite:setAnimation(animation)

    self.sprite:setRandomAnimationPosition()
  end

  -- Todo: Rethink this...
  self.img_color_filter = {255, 255, 255, 255}

  self.frills = {}

  self.game = game
  self.world = world
  self:add(x, y, w, h)

  self:initializeComponents(t.components)
end

function Base:add(x, y, w, h)
  self.world:add(self, x, y, w, h)
  self.game:addEntity(self)
end

function Base:remove()
  self:removeFrill()

  self.world:remove(self)
  self.game:removeEntity(self)
end

function Base:removeFrill()
  for _, frill in pairs(self.frills) do
    frill:remove()
  end
end

function Base:addFrill(class, t)
  t = t or {}
  t.parent = self

  local frill = class:new(t)
  table.insert(self.frills, frill)

  self.game.camera:addToLayer(frill.layer, frill)
end

function Base:getRect()
  return self.world:getRect(self)
end

function Base:setPosRel(relX, relY)
  local x, y = self:getRect()
  self.world:update(self, relX + x, relY + y)
end

function Base:move(rel_x, rel_y)
  local x, y = self:getRect()

  local actualX, actualY, cols, len = self.world:move(self, x + rel_x, y + rel_y, self.bumpFilter)

  for i, col in ipairs(cols) do
    self:handleComponentCollision(col)
  end

  local actualRelativeX, actualRelativeY = actualX - x, actualY - y

  return actualRelativeX, actualRelativeY, cols, len
end

function Base.bumpFilter(this, other)
  if other.solid then
    return 'slide'

  -- elseif other.solid_top then
  --   local _, this_y, _, this_h = this:getRect()
  --   local _, other_y = other:getRect()
  --   local is_fully_above = (this_y + this_h) <= other_y

  --   return util.choose(is_fully_above, 'slide', false)

  else
    return 'cross'
  end
end

function Base:queryCollision(filter)
  local x,y,w,h = self:getRect()

  return self.world:queryRect(x,y,w,h, filter)
end

function Base:queryCollisionAtFeet(filter)
  local x,y,w,h = self:getRect()

  return self.world:queryRect(x, y + h, w, 1, filter)
end

function Base:update(dt)
  self:updateComponents(dt)
  self:updateFrill(dt)
end

function Base:updateFrill(dt)
  for _,f in pairs(self.frills) do
    if f.update then
      f:update(dt)
    end
  end
end

function Base:isVisible(camX, camY, camW, camH)
  local selfX, selfY = self:getRect()
  local _, _, selfW, selfH = self.sprite:getViewport()

  return (selfX + selfW) > camX
     and (selfY + selfH) > camY
     and selfX < camX + camW
     and selfY < camY + camH
end

function Base:draw()
  local x, y = self:getRect()

  -- TODO: Hackish...
  x = x + self.drawOffsetX
  y = y + self.drawOffsetY

  love.graphics.setColor(unpack(self.img_color_filter))
  self.sprite:draw(x, y)
  love.graphics.setColor(255,255,255,255)
end

return Base
