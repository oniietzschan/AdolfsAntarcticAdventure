local C = class('VrilHarvester', Tile)

function C.validateTile(tile)
  return tile:isInstanceOf(Crystal)
end

function C.validateResources()
  return game.steel >= VRIL_HARVESTER_STEEL_COST
end

function C:initialize(...)
  Tile.initialize(self, ...)

  game:removeSteel(VRIL_HARVESTER_STEEL_COST)
end

function C:getDefaultAnimation()
  return 'vrilHarvester'
end

function C:endTurn()
  game:addVrilForce(VRIL_GENERATION_RATE)
end

function C:hover()
  return {
    name = 'Vril Harvester',
    gameplay = 'Generates ' .. VRIL_GENERATION_RATE .. ' Vril Force each turn.',
  }
end

return C
