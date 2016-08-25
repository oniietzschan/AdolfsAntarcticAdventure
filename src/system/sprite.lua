local Mokyu = require 'lib.mokyu.mokyu'

local sprite = {}

local function img(path)
  return love.graphics.newImage(path)
end

sprite.player = Mokyu.newSprite(img('assets/player.png'), 15, 22)
  :setOriginRect(4, 10, 7, 12)
  :addAnimation('air', {
    15,
  })
  :addAnimation('stand', {
    7,
  })
  :addAnimation('walk', {
    frequency = 1.9,
    1, 2, 3, 4, 5,
  })

sprite.tiles = Mokyu.newSprite(img('assets/tiles.png'), 16, 16)
  :addAnimation('block', {4})

return sprite
