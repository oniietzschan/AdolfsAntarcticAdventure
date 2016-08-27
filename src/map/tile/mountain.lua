local C = class('Mountain', Tile)

function C:initialize(...)
  Tile.initialize(self, ...)
end

function C:getDefaultAnimation()
  return 'mountain'
end

function C:hover()
  return {
    name = 'Mountains',
    gameplay = 'Impassable, except by flying units.'
  }
end

return C
