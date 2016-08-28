local C = class('Mine', Tile)

function C.validateTile(tile)
  return tile:isInstanceOf(SteelMountain)
end

function C.validateResources()
  return game.steel >= MINE_STEEL_COST
end

function C:initialize(...)
  Tile.initialize(self, ...)

  game:removeSteel(MINE_STEEL_COST)

  self.impassable = true
end

function C:getDefaultAnimation()
  return 'mine'
end

function C:endTurn()
  game:addSteel(MINE_GENERATION_RATE)
end

function C:hover()
  return {
    name = 'Mine',
    gameplay = 'Generates ' .. MINE_GENERATION_RATE .. ' steel each turn.',
  }
end

return C
