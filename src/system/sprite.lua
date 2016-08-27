local Mokyu = require 'lib.mokyu.mokyu'

local sprite = {}

local function img(path)
  return love.graphics.newImage('assets/' .. path .. '.png')
end

sprite.buttonBuildMine = img('button_build_mine')
sprite.buttonBuildVrilHarvester = img('button_build_vril_harvester')
sprite.buttonEndTurn = img('button_end_turn')

sprite.tiles = Mokyu.newSprite(img('tiles'), 32, 77)
  :setOriginRect(0, 50, 32, 17)
  :addAnimation('tundra', {1})
  :addAnimation('mountain', {2})
  :addAnimation('crystal', {3, 4})
  :addAnimation('mine', {5})
  :addAnimation('vrilHarvester', {6})


return sprite
