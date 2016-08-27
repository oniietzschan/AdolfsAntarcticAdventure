local C = class('Mine', Tile)

function C.validateTile(tile)
  return tile:isInstanceOf(Mountain)
end

function C.validateResources()
  return game.steel >= MINE_STEEL_COST
end

function C:initialize(...)
  Tile.initialize(self, ...)

  game:removeSteel(MINE_STEEL_COST)
end

function C:getDefaultAnimation()
  return 'mine'
end

return C
