local MapFactory = class('MapFactory')

function MapFactory:initialize(tbl)
  self.world = tbl.world
end

function MapFactory:generateLevel()
  StartingRoom({x = 0, y = 0})
end

return MapFactory
