local walkable = 0

local Grid       = require 'lib.jumper.grid'
local Pathfinder = require 'lib.jumper.pathfinder'

local PF = {}

function PF:getMoveablePositions(unit)
  local moveablePositions = {}

  local map = unit.tile.map
  local finder = self:getPathfinder(map)

  for _, destTile in pairs(map.tiles) do
    -- Define start and goal locations coordinates
    local startX, startY = unit.tile.x + 1, unit.tile.y + 1
    local endX, endY = destTile.x + 1, destTile.y + 1

    -- Define Stats for validation
    local destDistance = math.abs(startX - endX) + math.abs(startY - endY)
    local destUnit = map:getUnit(destTile.x, destTile.y)


    if destDistance <= unit:getMovementRange() and (destUnit == nil or destUnit:isFriendly() == false) then
      -- If Destination is valid, determine if path exists.
      local path = finder:getPath(startX, startY, endX, endY)

      if path and path:getLength() <= unit:getMovementRange() then
        table.insert(moveablePositions, {x = destTile.x, y = destTile.y})
      end
    end
  end

  return moveablePositions
end

function PF:getPath(tileStart, tileEnd)
  local finder = self:getPathfinder(tileStart.map)

  local startX, startY = tileStart.x + 1, tileStart.y + 1
  local endX, endY = tileEnd.x + 1, tileEnd.y + 1

  local path = finder:getPath(startX, startY, endX, endY)

  if path == nil then
    error('no path here... baka...')
  end

  return self:pathOneToZero(path)
end

function PF:pathOneToZero(path)
  for node, count in path:nodes() do
    node.x = node.x - 1
    node.y = node.y - 1
  end

  return path
end

function PF:getPathfinder(map)
  local mapData = {}

  for y = 0, MAP_TILES_Y - 1 do
    local line = {}
    for x = 0, MAP_TILES_X - 1 do
      local tile = map.tiles[pos(x, y)]
      local solid = tile:isPassable() and 0 or 1

      table.insert(line, solid)
    end
    table.insert(mapData, line)
  end

  local grid = Grid(mapData)

  local finder = Pathfinder(grid, 'JPS', walkable)
  finder:setMode('ORTHOGONAL')

  return finder
end

function PF:test(unit)
  local map = unit.tile.map
  local grid = self:mapToGrid(map)

  local finder = Pathfinder(grid, 'JPS', walkable)
  finder:setMode('ORTHOGONAL')

  -- Define start and goal locations coordinates
  local startx, starty = unit.tile.x + 1, unit.tile.y + 1
  local endx, endy = 3,3

  -- Calculates the path, and its length
  local path = finder:getPath(startx, starty, endx, endy)

  print(path)

  if path then
    print(('Path found! Length: %.2f'):format(path:getLength()))

    map:clearColors()

    for node, count in path:nodes() do
      local x, y = node.x - 1, node.y - 1
      print(('Step: %d - x: %d - y: %d'):format(count, x, y))

      if count > 1 then
        map:setColor(x, y, COLOR_HIGHLIGHT_BLUE)
      end
    end
  end
end

return PF
