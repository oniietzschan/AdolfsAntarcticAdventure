local Mokyu = require 'lib.mokyu.mokyu'

local sprite = {}

local function img(path)
  return love.graphics.newImage('assets/' .. path .. '.png')
end

sprite.buttonBuildMine = img('button_build_mine')
sprite.buttonBuildVrilHarvester = img('button_build_vril_harvester')
sprite.buttonEndTurn = img('button_end_turn')

sprite.agarthan = Mokyu.newSprite(img('agarthan'), 32, 55)
  :setOriginRect(0, 28, 32, 17)
  :addAnimation('active', {
    frequency = 0.25,
    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 4, 4, 4, 4, 4, 5, 5, 4, 4, 4, 3,
  })
  :addAnimation('stopped', {
    frequency = 0.9,
    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2,
  })

sprite.agarthanMonolith = Mokyu.newSprite(img('agarthan_monolith'), 32, 77)
  :setOriginRect(0, 50, 32, 17)
  :addAnimation('active', {1})
  :addAnimation('stopped', {1})

sprite.panzer = Mokyu.newSprite(img('panzer'), 32, 45)
  :setOriginRect(0, 18, 32, 17)
  :addAnimation('active', {
    frequency = 1.35,
    1, 2, 1, 2, 3, 4, 3, 4
  })
  :addAnimation('stopped', {2})

sprite.tiles = Mokyu.newSprite(img('tiles'), 32, 77)
  :setOriginRect(0, 50, 32, 17)
  :addAnimation('tundra', {1})
  :addAnimation('mountain', {2})
  :addAnimation('crystal', {3, 4})
  :addAnimation('vrilHarvester', {5})
  :addAnimation('steelMountain', {6})
  :addAnimation('mine', {7})
  -- :addAnimation('agarthanMonolith', {8})


return sprite
