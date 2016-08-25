local Room = class('Room')

function Room:initialize(tbl)
  self.world = tbl.world
  self.x = tbl.x
  self.y = tbl.y
  self.w = 10
  self.h = 8

  self:generate(tbl)
end

function Room:createRect(t_rect, t_ent)
  local offset_x = t_rect.x or 0
  local offset_y = t_rect.y or 0
  local w = t_rect.w or 1
  local h = t_rect.h or 1

  for x = offset_x, (w + offset_x - 1) do
    for y = offset_y, (h + offset_y - 1) do
      t_ent.x = x
      t_ent.y = y
      self:createEntity(t_ent)
    end
  end
end

function Room:createEntity(t)
  self:validatePosition(t)

  t.x = (self.x + t.x) * 16
  t.y = (self.y + t.y) * 16

  -- Todo: Is it better to add floor to world from here?
  -- self.world:add({name="floor"}, ent.x, ent.y, 16, 16)

  return t.class(t)
end

function Room:validatePosition(t)
  if t.x >= self.w or t.y >= self.h or t.x < 0 or t.y < 0 then
    error('ERROR: Invalid Entity Position, outside of room bounds! (x:' .. t.x .. ', y:' .. t.y .. ')', 2)
  end
end

return Room
