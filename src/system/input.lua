local boipushy = require 'lib.boipushy'

local Input = {
  _input = nil,
}

local _input = nil

function Input.initialize()
  _input = boipushy()

  local default_binds = {
    [LEFT_CLICK] = {'mouse1'},
    -- [UP] = {'w', 'up', 'dpup'},
    -- [DOWN] = {'s', 'down', 'dpdown'},
    -- [LEFT] = {'a', 'left', 'dpleft'},
    -- [RIGHT] = {'d', 'right', 'dpright'},
    -- [CONFIRM] = {'z', 'fdown'},
    -- [CANCEL] = {'x', 'fright'},
    [FULLSCREEN] = {'f'},
    [QUIT] = {'escape', 'back', 'start'},
    [PLUS] = {'+', '=', 'kp+'},
    [MINUS] = {'-', '_', 'kp-'},
  }

  for action, binds in pairs(default_binds) do
    for i, bind in pairs(binds) do
      _input:bind(bind, action)
    end
  end
end

function Input.handle()
  Input.globalInput()
end

function Input.pressed(...)
  return _input:pressed(...) == true
end

function Input.down(...)
  return _input:down(...) == true
end

function Input.released(...)
  return _input:released(...) == true
end

function Input.globalInput()
  if _input:pressed(PLUS) then
    screen:increaseScale()
  end
  if _input:pressed(MINUS) then
    screen:decreaseScale()
  end
  if _input:pressed(FULLSCREEN) then
    screen:toggleFullscreen()
  end
  if _input:pressed(QUIT) then
    love.event.push('quit')
  end
end

return Input
