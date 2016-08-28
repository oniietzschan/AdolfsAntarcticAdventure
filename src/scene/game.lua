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

  if self:tryToBuild()         then return end
  if self:tryToStartMove()     then return end
  if self:tryToExecuteMove()   then return end
  if self:tryToExecuteAttack() then return end

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

  if unit == nil or unit:isFriendly() == false or unit:canMove() == false then
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

function Game:tryToExecuteMove()
  if self.mode ~= MOVE or self.moveSubject == nil then
    return false
  end

  local tile = self.map.selectedTile

  if tile == nil or self:isMoveOkay(tile.x, tile.y) == false then
    return false
  end

  if self.map:getUnit(tile.x, tile.y) then
    error('Destination has a unit??')
  end

  local unit = self.moveSubject

  self:performMove(unit, tile)

  -- Check if Units are nearby, and switch to attack mode if they are.
  local enemiesOnlyFunc = function(u) return u:isFriendly() == false end
  local unitsInRange = self:getUnits(unit, unit:getAttackRange(), enemiesOnlyFunc)
  if #unitsInRange >= 1 then
    self:setMode(ATTACK)
    self:clearMoveOkay()

    -- Highlight targets in Red, and mark them as "Move" Okay
    for _, unit in ipairs(unitsInRange) do
      self.moveOkay[pos(unit.tile.x, unit.tile.y)] = true

      self.map:setColor(unit.tile.x, unit.tile.y, COLOR_HIGHLIGHT_RED)
      self.map:setUnitColor(unit.tile.x, unit.tile.y, COLOR_HIGHLIGHT_REALLY_RED)
    end

  else
    -- No units near destination, just end turn...
    self:setMode(NORMAL)
    unit:setAttacked(true)
  end

  return true
end

function Game:getUnits(subject, maxDistance, filter)
  local units = {}

  for _, unit in ipairs(self.map:getAllUnits()) do
    local distance = math.abs(subject.tile.x - unit.tile.x) + math.abs(subject.tile.y - unit.tile.y)
    if unit ~= subject and distance <= maxDistance and filter(unit) then
      table.insert(units, unit)
    end
  end

  return units
end

function Game:tryToExecuteAttack()
  if self.mode ~= ATTACK or self.moveSubject == nil then
    return false
  end

  local tile = self.map.selectedTile

  if tile == nil or self:isMoveOkay(tile.x, tile.y) == false then
    return false
  end

  self:performAttack(
    self.moveSubject,
    self.map:getUnit(tile.x, tile.y)
  )
end

function Game:performAttack(attacker, defender)
  -- -- Move attacker closer to defender if needed.
  -- local path = Pathfind:getPath(attacker.tile, defender.tile)

  -- for node, count in path:nodes() do
  --   if count == path:getLength() then -- lol...
  --     self:performMove(attacker, self.map:getTile(node.x, node.y))
  --   end
  -- end

  -- Deal damage.
  defender:takeDamage(attacker:getAttack())

  if defender.hp == 0 then
    defender:remove()
  end
end

function Game:performMove(unit, destTile)
  self.map:setUnit(unit.tile.x, unit.tile.y, nil)
  self.map:setUnit(destTile.x, destTile.y, unit)

  unit:setMoved(true)
end

function Game:isMoveOkay(x, y)
  return self.moveOkay[pos(x, y)] == true
end

function Game:setMoveOkay(positions)
  self:clearMoveOkay()

  for _, p in ipairs(positions) do
    self.moveOkay[pos(p.x, p.y)] = true
    self.map:setColor(p.x, p.y, COLOR_HIGHLIGHT_BLUE)
  end
end

function Game:clearMoveOkay()
  self.map:clearColors()
  self.map:clearUnitColors()

  self.moveOkay = {}
end

function Game:setMode(mode)
  if self.mode == ATTACK and self.moveSubject:canAttack() then

  end

  self.mode = mode

  if self.mode == ATTACK then
    self:clearMoveOkay()

  elseif self.mode == NORMAL then
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
