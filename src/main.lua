require 'lib/strict'

function pos(x, y)
  return x .. ',' .. y
end

class          = require 'lib.middleclass'
Serpent        = require 'lib.serpent'
Timer          = require 'lib.hump.timer'
Terebi         = require 'lib.terebi.terebi'

require 'system.constants'

Util     = require 'system.util'
Input    = require 'system.input'
Pathfind = require 'system.pathfind'
Sprite   = require 'system.sprite'

Map  = require 'map.map'

Tile          = require 'map.tile.tile'
Crystal       = require 'map.tile.crystal'
Mine          = require 'map.tile.mine'
Mountain      = require 'map.tile.mountain'
SteelMountain = require 'map.tile.steel_mountain'
VrilHarvester = require 'map.tile.vril_harvester'

Shake = require 'map.unit.trait.shake'

Unit             = require 'map.unit.unit'
Enemy            = require 'map.unit.enemy'
Agarthan         = require 'map.unit.agarthan'
AgarthanMonolith = require 'map.unit.agarthan_monolith'
Panzer           = require 'map.unit.panzer'

Button = require 'ui.button'

-- Base   = require 'entity.base'

-- BaseFrill = require 'entity.frill.base_frill'
-- Frill     = require 'entity.frill.frill'
-- Particles = require 'entity.frill.particles'

-- Seibutsu = require 'entity.seibutsu.seibutsu'
-- Player   = require 'entity.seibutsu.player'

Scene = require 'scene.scene'
Game  = require 'scene.game'
Ui    = require 'scene.ui'

game = nil
ui = nil

screen = nil
local scenes = {}

function love.load(arg)
  initGraphics()
  initInput()
  initScenes()
end

function initGraphics()
  Terebi.initializeLoveDefaults()

  screen = Terebi.newScreen(SCREEN_WIDTH, SCREEN_HEIGHT, SCREEN_SCALE)
end

function initInput()
  Input.initialize()
end

function initScenes()
  table.insert(scenes, Game({running = true, display = true}))
  table.insert(scenes, Ui({running = true, display = true}))
end

function love.update(dt)
  Input.handle()
  Timer.update(dt)

  for _,scene in pairs(scenes) do
    if scene:isRunning() then
      scene:update(dt)
    end
  end
end

function love.draw()
  lg.setCanvas(screen:getCanvas())

  for _,scene in pairs(scenes) do
    if scene:isDisplay() then
      scene:draw()
    end
  end

  screen:draw()
end
