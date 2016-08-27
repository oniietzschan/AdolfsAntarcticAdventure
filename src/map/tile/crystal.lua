local C = class('Mountain', Tile)

function C:initialize(...)
  Tile.initialize(self, ...)
end

function C:getDefaultAnimation()
  return 'crystal'
end

function C:hover()
  return {
    name = 'Vril Source',
    gameplay = 'Build a Vril Harvester here to generate Vril Force.',
  }
end

return C
