local bump = require 'lib.bump'

local Camera = require 'entity.camera'

local Game = class('Game', Scene)

local ONE_FRAME_30FPS = 0.03333

function Game:initialize(t)
  game = self

  Scene.initialize(self, t)

  self.map = Map()

  self.steel = 100
  self.vril = 25
end

function Game:update(dt)
  -- Game pauses execution during window drag, so limit frame time to 30FPS.
  dt = math.min(dt, ONE_FRAME_30FPS)

  self.map:update(dt)

  self:handleBuilding()
end

function Game:handleBuilding()
  if self.map.selectedTile == nil
    or self.toBuild == nil
    or Input.pressed(LEFT_CLICK) == false
    or self.selectedButton ~= nil
    or self.toBuild.validateTile(self.map.selectedTile) == false
    or self.toBuild.validateResources() == false
  then
    return false
  end

  self.map:setTile(
    self.map.selectedTile.x,
    self.map.selectedTile.y,
    self.toBuild(self.map)
  )

  self.map:storeOrderedTiles()
end

function Game:draw()
  self:fillBackgroundColor()

  self.map:draw()
end

function Game:fillBackgroundColor()
  lg.setColor(COLOR_BACKGROUND)
  lg.rectangle('fill', 0, 0, CAMERA_WIDTH, CAMERA_HEIGHT)
end

function Game:endTurn()
  self.map:endTurn()
end

function Game:addSteel(i)
  self.steel = self.steel + i
end

function Game:removeSteel(i)
  self.steel = self.steel - i
end

function Game:addVrilForce(i)
  self.vril = self.vril + i
end

function Game:removeVrilForce(i)
  self.vril = self.vril - i
end

-- function Game:initWorld()
--   self._entities = {}

--   self.world = bump.newWorld(16)
--   world = self.world

--   local factory = MapFactory({world = self.world})
--   factory:generateLevel()
-- end

-- function Game:initCamera()
--   self.camera = Camera(self)

--   self.camera:newLayer('background')
--   self.camera:newLayer('entity')
--   self.camera:newLayer('foreground')

--   self._debug_draw_bump = false
-- end

-- function Game:addEntity(ent)
--   self:addIdIfMissing(ent)

--   self._entities[ent.id] = ent

--   self.camera:addToLayer(ent.layer, ent)
-- end

-- function Game:addIdIfMissing(ent)
--   if ent.id then
--     return
--   end

--   ent.id = self.nextId
--   self.nextId = self.nextId + 1
-- end

-- function Game:removeEntity(ent)
--   self._entities[ent.id] = nil

--   self.camera:removeFromLayer(ent.layer, ent)
-- end

return Game
