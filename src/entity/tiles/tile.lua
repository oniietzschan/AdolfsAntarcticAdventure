local Tile = class('Tile', Base)

function Tile:initialize(t)
  t.sprite = t.sprite or Sprite.tiles
  t.solid = t.solid or false

  Base.initialize(self, t)
end

function Tile:isNeighbourSameClass(rel_x, rel_y)
  local x,y,w,h = self:getRect()
  x = x + rel_x
  y = y + rel_y
  local filter = function(other)
    return other.class == self.class.name
  end
  local _, len = self.world:queryRect(x,y,w,h, filter)

  return len >= 1
end

return Tile
