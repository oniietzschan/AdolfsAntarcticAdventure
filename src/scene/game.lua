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
  self:clearActionOkay()
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
  if Input.pressed(LEFT_CLICK) == false then
    return
  end

  if self.map.selectedTile then
    if self:tryToBuild()         then return end
    if self:tryToStartMove()     then return end
    if self:tryToExecuteMove()   then return end
    if self:tryToExecuteAttack() then return end
  end

  self:setMode(NORMAL)
end

function Game:startBuilding(toBuild)
  self:setMode(BUILD)

  self.toBuild = toBuild

  do -- Set buildable locations
    local allies = self.map:filterUnits(function(u) return u:isFriendly() end)
    local buildableTiles = self.map:filterTiles(function(tile)
      for _, ally in ipairs(allies) do
        if Util.getDistance(tile, ally.tile) <= BUILD_RANGE then
          return true
        end
      end
    end)

    local positions = {}
    for _, tile in ipairs(buildableTiles) do
      table.insert(positions, {x = tile.x, y = tile.y})
    end

    self:setActionOkay(positions)
  end
end

function Game:tryToBuild()
  local tile = self.map.selectedTile

  if self.toBuild == nil
    or self.selectedButton ~= nil
    or self:isActionOkay(tile.x, tile.y) == false
    or self.toBuild.validateTile(tile) == false
    or self.toBuild.validateResources() == false
  then
    return false
  end

  -- OK! Perform Build
  self.map:setTile(tile.x, tile.y, self.toBuild(self.map))

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
  self:setActionOkay(moveablePositions)

  self.moveSubject = unit

  return true
end

function Game:tryToExecuteMove()
  if self.mode ~= MOVE or self.moveSubject == nil then
    return false
  end

  local unit = self.moveSubject
  local tile = self.map.selectedTile

  if tile == nil or self:isActionOkay(tile.x, tile.y) == false then
    return false
  end

  if self.map:getUnit(tile.x, tile.y) and self.map:getUnit(tile.x, tile.y) ~= unit then
    error('Destination has a unit??')
  end

  self:performMove(unit, tile)

  -- Check if Units are nearby, and switch to attack mode if they are.
  local enemyUnitsInRange = self.map:filterUnits(function(u)
    if u:isFriendly() then
      return false
    end

    local distance = math.abs(u.tile.x - unit.tile.x) + math.abs(u.tile.y - unit.tile.y)
    if distance > unit:getAttackRange() then
      return false
    end

    return true
  end)
  if #enemyUnitsInRange >= 1 then
    -- Enemies are in range, so switch to attack mode!! FAITO!!
    self:setMode(ATTACK)
    self:clearActionOkay()

    -- Highlight targets in Red, and mark them as "Move" Okay
    for _, unit in ipairs(enemyUnitsInRange) do
      self.actionOkay[pos(unit.tile.x, unit.tile.y)] = true

      self.map:setColor(unit.tile.x, unit.tile.y, COLOR_HIGHLIGHT_REALLY_RED)
      self.map:setUnitColor(unit.tile.x, unit.tile.y, COLOR_HIGHLIGHT_REALLY_RED)
    end

  else
    -- No units near destination, just end turn...
    self:setMode(NORMAL)
    unit:setAttacked(true)
  end

  return true
end

function Game:tryToExecuteAttack()
  local unit = self.moveSubject

  if self.mode ~= ATTACK or unit == nil then
    return false
  end

  local tile = self.map.selectedTile

  if tile == nil or self:isActionOkay(tile.x, tile.y) == false then
    return false
  end

  self:performAttack(unit, self.map:getUnit(tile.x, tile.y))

  self:setMode(NORMAL)
  unit:setAttacked(true)
  unit:setMoved(true) -- in case of standing ground before attack

  return true
end

function Game:performAttack(attacker, defender)
  defender:takeDamage(attacker:getAttack())
end

function Game:performMove(unit, destTile, callback)
  if unit.tile.x ~= destTile.x or unit.tile.y ~= destTile.y then
    unit:setMoved(true)
  end

  self:animateMovement(unit, destTile, callback)

  self.map:setUnit(destTile.x, destTile.y, unit)
end

function Game:animateMovement(unit, destTile, callback)
  local filter = function(tile)
    return tile.unit and tile.unit:isFriendly() ~= unit:isFriendly()
  end
  local path = Pathfind:getPath(unit.tile, destTile, filter)
  local tiles = Pathfind:getTilesAlongPath(path, self.map)

  -- Sorry... Progressively move through each tile.
  unit.drawAtX, unit.drawAtY = unit.tile:getDrawOffset()
  Chain(
    unpack(
      _.map(tiles, function(i, tile)
        return function (go)
          local x, y = tile:getDrawOffset()

          unit.sprite:setMirrored(unit.drawAtX < x)

          Timer.tween(0.15, unit, {drawAtX = x, drawAtY = y}, 'linear')
          Timer.after(0.15, go)

          -- execute callback after final move.
          if callback and i == #tiles then
            Timer.after(0.15, function()
              callback()
            end)
          end
        end
      end)
    )
  )()
end

function Game:isActionOkay(x, y)
  return self.actionOkay[pos(x, y)] == true
end

function Game:setActionOkay(positions)
  self:clearActionOkay()

  local color = COLOR_HIGHLIGHT_BLUE
  if self.mode == BUILD then
    color = COLOR_HIGHLIGHT_GREEN
  end

  for _, p in ipairs(positions) do
    self.actionOkay[pos(p.x, p.y)] = true
    self.map:setColor(p.x, p.y, color)
  end
end

function Game:clearActionOkay()
  self.map:clearColors()
  self.map:clearUnitColors()

  self.actionOkay = {}
end

function Game:setMode(mode)
  -- If cancelling attack after moving a unit, that unit should lose it's attack.
  if self.mode == ATTACK and self.moveSubject:canMove() == false and self.moveSubject:canAttack() then
    self.moveSubject:setAttacked(true)
  end

  self.mode = mode

  if self.mode == ATTACK then
    self:clearActionOkay()

  elseif self.mode == NORMAL then
    self.toBuild = nil
    self:clearActionOkay()
    self.moveSubject = nil
  end
end

function Game:endTurn()
  self:setMode(NORMAL)

  self:moveEnemies()

  self.map:endTurn()
end

function Game:moveEnemies()
  local allies  = self.map:filterUnits(function(u) return u:isFriendly() == true end)
  local enemies = self.map:filterUnits(function(u) return u:isFriendly() == false end)
  local aiData = {}

  if #allies == 0 or #enemies == 0 then
    return
  end

  -- 1. Determine nearest target for each enemy
  for _, enemy in ipairs(enemies) do
    if enemy:canMove() and enemy:canAttack() then
      local data = {
        enemy = enemy,
        unitPaths = {},
      }
      table.insert(aiData, data)

      -- 1A. Get paths to all allies
      for _, ally in ipairs(allies) do
        local path = Pathfind:getPath(enemy.tile, ally.tile)
        if path then
          table.insert(data.unitPaths, path)
        end
      end

      if #data.unitPaths == 0 then
        error('No paths?? WTF')
      end

      -- 1B. Sort paths internally by distance ASC
      table.sort(data.unitPaths, function(a, b) return a:getLength() < b:getLength() end)

      -- 1C. Store shortest path
      data.closestUnitDist = data.unitPaths[1]:getLength()
    end
  end

  -- 2. Enemies move in order of proximity
  table.sort(aiData, function(a, b) return a.closestUnitDist < b.closestUnitDist end)
  for _, data in ipairs(aiData) do

    self:enemyMovesThenAttacks(data)
  end
end

function Game:enemyMovesThenAttacks(data)
  local enemy = data.enemy

  for _, path in ipairs(data.unitPaths) do
    -- TODO: check if ally at end of path still exists!!

    -- Move as far as possible
    local furthestTile = nil
    for node, count in path:nodes() do
      if count <= enemy:getMovementRange() + 1 then
        local tile =  self.map:getTile(node.x, node.y)
        if tile.unit == nil then
          furthestTile = tile
        end
      end
    end
    if furthestTile then
      local callback = function()
        self:attackWithEnemy(data.enemy)
      end
      self:performMove(enemy, furthestTile, callback)
    else
      -- Wasn't able to move... try attacking anyways?
      self:attackWithEnemy(data.enemy)
    end

    -- exit if successfully followed path
    return true
  end
end

function Game:attackWithEnemy(enemy)
  local enemyUnitsInRange = self.map:filterUnits(function(u)
    local distance = math.abs(u.tile.x - enemy.tile.x) + math.abs(u.tile.y - enemy.tile.y)

    return u:isFriendly() and distance <= enemy:getAttackRange()
  end)
  if #enemyUnitsInRange == 0 then
    return
  end

  self:performAttack(enemy, enemyUnitsInRange[1])
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

function Game:draw()
  self:fillBackgroundColor()

  self.map:draw()
end

function Game:fillBackgroundColor()
  lg.setColor(COLOR_BACKGROUND)
  lg.rectangle('fill', 0, 0, CAMERA_WIDTH, CAMERA_HEIGHT)
end

return Game
