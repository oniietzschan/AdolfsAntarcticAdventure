local bump = require 'lib.bump'

local Camera = require 'entity.camera'

local Game = class('Game', Scene)

local ONE_FRAME_30FPS = 0.03333

function Game:initialize(t)
  t = t or {}

  game = self

  Scene.initialize(self, t)

  self.nextId = 1

  self:initCamera()
  self:initWorld()
end

function Game:initWorld()
  self._entities = {}

  self.world = bump.newWorld(16)
  world = self.world

  local factory = MapFactory({world = self.world})
  factory:generateLevel()
end

function Game:initParallax()
  local numOfClouds = rng(8, 10)
  for i = 1, numOfClouds do
    local cloud = Parallax({
      x = ((newRng() - 0.5 + i) / numOfClouds) * (CAMERA_WIDTH + CAMERA_MAX_X * LAYER_CLOUDS_SCALE_X),
      y = (newRng() * 0.35 + 0.25) * (CAMERA_HEIGHT + CAMERA_MAX_Y * LAYER_CLOUDS_SCALE_Y),
      img = img.cloud,
      layer= 'clouds',
    })
    self:addEntity(cloud)
  end
end

function Game:initCamera()
  self.camera = Camera(self)

  self.camera:newLayer('background')
  self.camera:newLayer('entity')
  self.camera:newLayer('foreground')
  -- self.camera:newLayer('debug', 1, 1, function(camX, camY) self:drawDebug(camX, camY) end)

  self._debug_draw_bump = false
end

function Game:update(dt)
  -- Game pauses execution during window drag, so limit frame time to 30FPS.
  dt = math.min(dt, ONE_FRAME_30FPS)

  for i,ent in pairs(self._entities) do
    ent:update(dt)
  end
end

function Game:draw()
  self:fillBackgroundColor()
  self.camera:draw()
  -- self:drawDebug()
end

function Game:fillBackgroundColor()
  lg.setColor(150, 181 , 218)
  lg.rectangle('fill', 0, 0, CAMERA_WIDTH, CAMERA_HEIGHT)
end

-- function Game:drawDebug(camX, camY)
--   if (self._debug_draw_bump == false) then
--     return
--   end

--   -- Select debug canvas
--   local prev_canvas = lg.getCanvas()
--   lg.setCanvas(canvas_debug)
--   lg.clear()

--   -- Draw bounding boxes
--   local camPosX, camPosY = self.camera:getPosScaled(1, 1)
--   for _,item in ipairs(self.world:getItems()) do
--     if item:isVisible(camPosX, camPosY, CAMERA_WIDTH, CAMERA_HEIGHT) then
--       lg.setColor(
--         (item.solid) and {0, 0, 255} or {255, 0, 0}
--       )
--       local x, y, w, h = self.world:getRect(item)
--       -- subtract (w - 1) and (h - 1) to draw inner border only.
--       lg.rectangle('line', math.floor(x + 1.5), math.floor(y + 1.5), w - 1, h - 1)
--     end
--   end

--   -- Switch to primary canvas and draw debug canvas overtop
--   local cameraTransPosX, cameraTransPosY = self.camera:getPosForTranslation(1, 1)
--   lg.setCanvas(prev_canvas)
--   lg.setColor(255, 255, 255, 128)
--   lg.draw(canvas_debug, -cameraTransPosX, -cameraTransPosY)

--   lg.setColor(255, 255, 255, 255)
-- end

function Game:addEntity(ent)
  self:addIdIfMissing(ent)

  self._entities[ent.id] = ent

  self.camera:addToLayer(ent.layer, ent)
end

function Game:addIdIfMissing(ent)
  if ent.id then
    return
  end

  ent.id = self.nextId
  self.nextId = self.nextId + 1
end

function Game:removeEntity(ent)
  self._entities[ent.id] = nil

  self.camera:removeFromLayer(ent.layer, ent)
end

return Game
