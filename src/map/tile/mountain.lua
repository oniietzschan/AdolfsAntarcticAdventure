local C = class('Mountain', Tile)

function C:initialize(...)
  Tile.initialize(self, ...)
end

function C:getDefaultAnimation()
  return 'mountain'
end

return C
