local StartingRoom = class('StartingRoom', Room)

function StartingRoom:generate()
  self:createRect({x = 3, y = 4, w = 3}, {class = Tile, solid = true, animation = 'block'})
  self:createRect({x = 2, y = 5, w = 5}, {class = Tile, solid = true, animation = 'block'})
  self:createRect({x = 1, y = 6, w = 7}, {class = Tile, solid = true, animation = 'block'})

  player = self:createEntity({x = 4, y = 0, class = Player})
end

return StartingRoom
