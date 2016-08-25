local C = class('Touches', Component)

function C:handleCollision(col)
  if col.other:hasComponent(Touchable) == false then
    return
  end

  col.other:trigger(EVENT_TOUCH, self.parent)
end

return C
