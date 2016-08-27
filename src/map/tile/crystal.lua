local C = class('Mountain', Tile)

function C:initialize(...)
  Tile.initialize(self, ...)
end

function C:getDefaultAnimation()
  return 'crystal'
end

return C
