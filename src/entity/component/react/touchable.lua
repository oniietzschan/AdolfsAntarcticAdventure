local C = class('Touchable', React)

function C:listen(event, ...)
  if event == EVENT_TOUCH then
    self:react(...)
  end
end

return C
