local Scene = class('Scene')

function Scene:initialize(t)
  t = t or {}

  -- print('Initializing Scene: ' .. self.class.name)

  self._display = t.display or false
  self._running = t.running or false
end

function Scene:isDisplay()
  return self._display
end

function Scene:setDisplay(val)
  self._display = val
end

function Scene:isRunning()
  return self._running
end

function Scene:setRunning(val)
  self._running = val
end

function Scene:draw()
end

function Scene:update()
end

return Scene
