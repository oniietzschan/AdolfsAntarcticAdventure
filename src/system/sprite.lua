local Mokyu = require 'lib.mokyu.mokyu'

local sprite = {}

local function img(path)
  return love.graphics.newImage('assets/' .. path .. '.png')
end

sprite.buttonBuildMine = img('button_build_mine')

sprite.tiles = Mokyu.newSprite(img('tiles'), 32, 77)
  :setOriginRect(0, 50, 32, 17)
  :addAnimation('tundra', {1})
  :addAnimation('mountain', {2})
  :addAnimation('crystal', {3, 4})
  :addAnimation('mine', {5})


return sprite
