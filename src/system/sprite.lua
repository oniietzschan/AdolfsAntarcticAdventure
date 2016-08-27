local Mokyu = require 'lib.mokyu.mokyu'

local sprite = {}

local function img(path)
  return love.graphics.newImage('assets/' .. path .. '.png')
end

sprite.tiles = Mokyu.newSprite(img('tiles'), 32, 77)
  :setOriginRect(0, 50, 32, 17)
  :addAnimation('tundra', {1})

sprite.player = Mokyu.newSprite(img('player'), 15, 22)
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

sprite.zztiles = Mokyu.newSprite(img('zztiles'), 16, 16)
  :addAnimation('block', {4})
  :addAnimation('mountain', {4})

return sprite
