local bump = require 'lib.bump'

local Camera = require 'entity.camera'

local Game = class('Game', Scene)

local ONE_FRAME_30FPS = 0.03333

function Game:initialize(t)
  game = self

  Scene.initialize(self, t)

  self.currentMap = 0
  self:nextMap()

  self:setMode(NORMAL)
  self:clearMoveOkay()
  self.steel = 100
  self.vril = 25
end

function Game:update(dt)
  -- Game pauses execution during window drag, so limit frame time to 30FPS.
  dt = math.min(dt, ONE_FRAME_30FPS)

  if self.mapFinished then
    self:nextMap()
  end

  self.map:update(dt)

  self:handleMapClick()
end

function Game:nextMap()
  self.currentMap = self.currentMap + 1
  self.mapFinished = false

  self.map = Map()
end

function Game:handleMapClick()
  if self.map.selectedTile == nil
    or Input.pressed(LEFT_CLICK) == false
  then
    return
  end

  if self:tryToBuild()       then return end
  if self:tryToStartMove()   then return end
  if self:tryToExecuteMove() then return end

  self:setMode(NORMAL)
end

function Game:tryToBuild()
  if self.toBuild == nil
    or self.selectedButton ~= nil
    or self.toBuild.validateTile(self.map.selectedTile) == false
    or self.toBuild.validateResources() == false
  then
    return false
  end

  -- OK! Perform Build
  self.map:setTile(
    self.map.selectedTile.x,
    self.map.selectedTile.y,
    self.toBuild(self.map)
  )

  self.map:storeOrderedTiles()

  self:setMode(NORMAL)

  return true
end

function Game:tryToStartMove()
  if self.mode == MOVE then
    return false
  end

  local unit = self.map.selectedTile.unit

  if unit == nil or unit:isAllowedToMove() == false then
    return false
  end

  self:setMode(MOVE)

  -- 1. determine acceptable spots
  local moveablePositions = Pathfind:getMoveablePositions(unit)

  -- 2. store on map
  self:setMoveOkay(moveablePositions)

  self.moveSubject = unit

  return true
end

function Game:setMoveOkay(positions)
  self:clearMoveOkay()

  for _, p in ipairs(positions) do
    self.moveOkay[pos(p.x, p.y)] = true

    if self.map:getUnit(p.x, p.y) then -- Unit on position: ATTACK!
      self.map:setColor(p.x, p.y, COLOR_HIGHLIGHT_RED)
      self.map:setUnitColor(p.x, p.y, COLOR_HIGHLIGHT_REALLY_RED)

    else -- Position free: MOVE!
      self.map:setColor(p.x, p.y, COLOR_HIGHLIGHT_BLUE)
    end
  end
end

function Game:tryToExecuteMove()
  if self.mode ~= MOVE or self.moveSubject == nil then
    return false
  end

  local tile = self.map.selectedTile

  if tile == nil or self:isMoveOkay(tile.x, tile.y) == false then
    return false
  end

  local unit = self.moveSubject
  local destUnit = self.map:getUnit(tile.x, tile.y)

  -- OK! Perform Attack And/Or Move
  if destUnit then
    self:performAttack(unit, destUnit)
  else
    self:performMove(unit, tile)
  end

  unit:setMoved(true)

  self:setMode(NORMAL)

  return true
end

function Game:isMoveOkay(x, y)
  return self.moveOkay[pos(x, y)] == true
end

function Game:performAttack(attacker, defender)
  -- Move attacker closer to defender if needed.
  local path = Pathfind:getPath(attacker.tile, defender.tile)

  for node, count in path:nodes() do
    if count == path:getLength() then -- lol...
      self:performMove(attacker, self.map:getTile(node.x, node.y))
    end
  end

  -- Deal damage.
  defender:takeDamage(attacker:getAttack())

  if defender.hp == 0 then
    defender:remove()
  end
end

function Game:performMove(unit, destTile)
  self.map:setUnit(unit.tile.x, unit.tile.y, nil)
  self.map:setUnit(destTile.x, destTile.y, unit)
end

function Game:clearMoveOkay()
  self.map:clearColors()
  self.map:clearUnitColors()

  self.moveOkay = {}
end

function Game:setMode(mode)
  self.mode = mode

  if self.mode == NORMAL then
    self.toBuild = nil
    self:clearMoveOkay()
    self.moveSubject = nil
  end
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
  self:setMode(NORMAL)

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

return Game
